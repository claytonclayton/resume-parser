{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Resume.Parser 
  ( Resume (Resume)
  , Intro (Intro)
  , Section 
    ( Section
    , sectionTitle
    )
  , SubBlock (SubBlock)
  , Dot (Dot)
  , Flat (Flat)
  , Parser
  , parseResume
  , parseSep
  , defaultBlockTraits
  , Element
    ( I
    , S
    , SB
    , B
    , D
    , F
    )
  , Line
    ( Line
    , getPos
    , getVal
    )
  , Block
    ( Block
    , blockTitle
    , blockTraits
    )
  , BlockTraits
    ( topLeft
    , topRight
    , botLeft
    , botRight
    )
  ) where

import Data.Text (Text)
import Data.Void
import Text.Megaparsec hiding (State)
import Text.Megaparsec.Char
import qualified Data.Text as T
import Control.Monad 
import Control.Monad.Trans.Maybe
import Control.Monad.Trans.Class

data Resume = Resume [Line]
  deriving (Eq)

instance Show Resume where
  show (Resume lines) =
    unlines (fmap show lines) 

data Intro = Intro
  { title      :: Text
  , traits     :: [Text]
  }
  deriving (Eq, Show)

data BlockTraits = BlockTraits
  { topLeft  :: Text 
  , topRight :: Text
  , botLeft  :: Text
  , botRight :: Text
  }
  deriving (Eq, Show)

defaultBlockTraits :: BlockTraits
defaultBlockTraits = BlockTraits
  { topLeft  = "" 
  , topRight = "" 
  , botLeft  = "" 
  , botRight = "" 
  }

data Block = Block
  { blockTitle  :: Text
  , blockTraits :: BlockTraits
  }
  deriving (Eq, Show)

data SubBlock = SubBlock
  { left  :: Text
  , right :: Text
  } 
  deriving (Eq, Show)

defaultSubBlock :: SubBlock
defaultSubBlock = SubBlock
  { left  = "" 
  , right = "" 
  }

data Flat = Flat
  { flatTitle  :: Text
  , flatRest   :: Text
  }
  deriving (Eq, Show)

data Section = Section
  { sectionTitle :: Text } 
  deriving (Eq, Show)

data Dot     = Dot Text
  deriving (Eq, Show)

data Line = Line
  { getPos   :: SourcePos
  , getVal :: Element
  } 
  deriving (Eq, Show)

data Element
  = I  Intro
  | S  Section
  | B  Block
  | SB SubBlock
  | D  Dot
  | F  Flat
  deriving (Eq, Show)

type Parser = Parsec FrechoError Text

data FrechoError = FrechoError String
  deriving (Eq, Ord, Show)

instance ShowErrorComponent FrechoError where
  showErrorComponent (FrechoError s) = "frechoError: " <> s

parseChars :: Parser Text
parseChars = 
  takeWhile1P Nothing (/= '\n') 

parseNot :: Char -> Parser Text
parseNot c = 
  takeWhileP Nothing (\x -> x /= c && x /= '\n') 

parseSep :: Char -> Parser [Text]
parseSep c = 
  (fmap . fmap) T.strip $ (parseNot c) `sepBy` char c 

-- traits should be optional
parseIntro :: Parser Intro
parseIntro = do 
  title  <- char '#' *> hspace *> parseChars
  newline
  traits <- parseSep '|'
  return Intro {..}
 
parseSection :: Parser Section
parseSection =
  fmap Section $ string "##" *> hspace *> parseChars

parseDot :: Parser Dot
parseDot = 
  fmap Dot $ char '-' *> hspace *> parseChars

-- have error message include the number of found '|'
parseBlockTraits :: Parser BlockTraits
parseBlockTraits = 
  liftM (maybe defaultBlockTraits id) . runMaybeT $ do 
    lift $ optional . try $ char '+' -- should be able to early exit with Nothing
    line <- lift $ parseSep '|'
    case line of
      [a]          -> return defaultBlockTraits {topRight = a}
      [a, b]       -> return defaultBlockTraits {topLeft = a, topRight = b}
      [a, b, c]    -> return defaultBlockTraits {topRight = a, botLeft = b, botRight = c}
      [a, b, c, d] -> return defaultBlockTraits {topLeft = a, topRight = b, botLeft = c, botRight = d}
      _            -> fail $ "blockTraits requires 0-3 '|'. " <> (show $ (+) (-1) . length $ line) <> " '|' found."
   
parseSubBlockStart :: Parser ()
parseSubBlockStart = void $ char '+' 

parseSubBlockEnd :: Parser SubBlock
parseSubBlockEnd = do
  line <- parseSep '|'
  subBlock <- case line of
    [a]    -> return defaultSubBlock {left = a}
    [a, b] -> return defaultSubBlock {left = a, right = b}
    _      -> fail "subBlockTraits requires 0-1 '|'"
  return subBlock

parseBlockStart :: Parser ()
parseBlockStart = do
  void $ string "###" *> hspace

parseBlockEnd :: Parser Block
parseBlockEnd = do
  blockTitle  <- parseChars 
  newline
  blockTraits <- parseBlockTraits
  return Block {..}

parseFlat :: Parser Flat
parseFlat = do
  line <- parseChars 
  let 
    (a, b) = T.span ((/=) ':') line 
    (flatTitle, flatRest) = 
      case b of
        "" -> ("", a)
        _  -> (a, T.strip $ T.drop 1 b)
  return Flat {..}

-- BIG QUESTIONS
  -- how does this function reduce?
  -- are the inner parsers: parseIntro, parseSection etc,
  -- lazily called first during the running of choice before
  -- makeLineParse is called or is makeLineParse called everytime?
  -- in which case is this a bad implementation since getSourcePos
  -- is apparently slow? (see docs)
-- should add 'try' on every parse
-- parseLine :: Parser Line
-- parseLine = do
--   makeLineParse $ firstCustomFailOrPass
--     [ B  <$> parseBlock
--     , S  <$> parseSection
--     , I  <$> parseIntro
--     , SB <$> parseSubBlock
--     , D  <$> parseDot
--     , F  <$> parseFlat
--     ] 
--   where 
--     makeLineParse p = Loc <$> getSourcePos <*> p 
--     firstCustomFailOrPass = foldr choicer mzero 
--     choicer p rest = do
--       r <- observing p
--       case r of 
--         Right x  -> return x
--         Left err -> maybe rest customFailure $ hasCustom err
-- 
-- hasCustom :: ParseError s e -> Maybe e
-- hasCustom (FancyError _ s) = msum $ fmap isCustom $ S.toList s 
--   where
--     isCustom (ErrorCustom e) = Just e
--     isCustom _               = Nothing
-- hasCustom _ = Nothing

parseLine :: Parser Line
parseLine = do
  makeLineParse $ choice 
    [ parseBlockStart *> (B <$> parseBlockEnd)
    , S <$> parseSection
    , I <$> parseIntro
    , parseSubBlockStart *> (SB <$> parseSubBlockEnd)
    , D <$> parseDot
    , F <$> parseFlat
    ]
  where
    makeLineParse p = Line <$> getSourcePos <*> p 

-- many "\n" inefficient?
parseResume :: Parser Resume
parseResume = do
  many "\n"
  lines <- many $ parseLine <* many "\n" 
  return $ Resume lines

