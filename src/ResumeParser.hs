{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module ResumeParser (ResumeADT(ResumeADT), Intro, Section(Section), Block(Block), SubBlock(SubBlock), Dot(Dot), Flat(Flat), Line(S, SB, D, F, B), Parser, parseResume, parseSep) where

import Control.Monad (when) 
import Data.Char (isAlphaNum)
import Data.Text (Text)
import Data.Void
import Text.Megaparsec hiding (State)
import Text.Megaparsec.Char
import qualified Data.Text as T
import Control.Monad (void)

someFunc :: IO ()
someFunc = putStrLn "someFunc"

data ResumeADT = ResumeADT [Line]
  deriving (Eq)

instance Show ResumeADT where
  show (ResumeADT lines) =
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
  , blockTraits :: Maybe BlockTraits
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
  { flatTitle  :: Maybe Text
  , flatRest   :: Text
  }
  deriving (Eq, Show)

data Section = Section Text
  deriving (Eq, Show)

data Dot     = Dot Text
  deriving (Eq, Show)

data Line = I Intro | S Section | B Block | SB SubBlock | D Dot | F Flat
  deriving (Eq, Show)

type Parser = Parsec Void Text

parseChars :: Parser Text
parseChars = 
  takeWhile1P Nothing (/= '\n') 

parseNot :: Char -> Parser Text
parseNot c = 
  takeWhileP Nothing (\x -> x /= c && x /= '\n') 

parseSep :: Char -> Parser [Text]
parseSep c = 
  (fmap . fmap) T.strip $ (parseNot c) `sepBy` char c 

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
parseBlockTraits :: Parser (Maybe BlockTraits)
parseBlockTraits =
  optional $ do
    char '+'
    line <- parseSep '|'
    traits <- case line of
         [a]          -> return defaultBlockTraits {topRight = a}
         [a, b]       -> return defaultBlockTraits {topLeft = a, topRight = b}
         [a, b, c]    -> return defaultBlockTraits {topRight = a, botLeft = b, botRight = c}
         [a, b, c, d] -> return defaultBlockTraits {topLeft = a, topRight = b, botLeft = c, botRight = d}
         _            -> fail "blockTraits requires 0-3 '|'"
    return traits

parseSubBlock :: Parser SubBlock
parseSubBlock = do
  char '+'
  line <- parseSep '|'
  subBlock <- case line of
       [a]          -> return defaultSubBlock {left = a}
       [a, b]       -> return defaultSubBlock {left = a, right = b}
       _            -> fail "subBlockTraits requires 0-1 '|'"
  return subBlock

parseBlock :: Parser Block
parseBlock = do
  blockTitle  <- string "###" *> hspace *> parseChars 
  newline
  blockTraits <- parseBlockTraits
  return Block {..}

parseFlat :: Parser Flat
parseFlat = do
  line <- parseChars 
  let (a, b) = T.span ((/=) ':') line 
      (flatTitle, flatRest) = 
        case b of
          "" -> (Nothing, a)
          _  -> (Just a, b)
  return Flat {..}

parseLine :: Parser Line
parseLine = 
  choice $ fmap try
  [ B  <$> parseBlock  
  , S  <$> parseSection
  , I  <$> parseIntro
  , SB <$> parseSubBlock
  , D  <$> parseDot
  , F  <$> parseFlat
  ]

-- many "\n" inefficient?
parseResume :: Parser ResumeADT
parseResume = do
  many "\n"
  lines <- many $ parseLine <* many "\n" 
  return $ ResumeADT lines

