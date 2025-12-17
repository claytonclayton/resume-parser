{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Lib (Resume, Intro, Block, Flat, Line, Parser, parseResume, parseSep) where

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

data Resume = Resume
  { intro      :: Intro 
  , lines      :: [Line]
  }
  deriving (Eq, Show)

data Intro = Intro
  { title      :: Text
  , traits     :: [Text]
  }
  deriving (Eq, Show)

data BlockTraits = BlockTraits
  { topRight :: Text
  , botLeft  :: Text
  , botRight :: Text
  }
  deriving (Eq, Show)

data Block = Block
  { blockTitle  :: Text
  , blockTraits :: Maybe BlockTraits
  }
  deriving (Eq, Show)

data Flat = Flat
  { flatTitle  :: Text
  , flatRest   :: Text
  }
  deriving (Eq, Show)

data Section = Section Text
  deriving (Eq, Show)

data Dot     = Dot Text
  deriving (Eq, Show)

data Line = S Section | B Block | D Dot | F Flat
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

parseBlockTraits :: Parser (Maybe BlockTraits)
parseBlockTraits =
  optional $ do
    char '+'
    line <- parseSep '|'
    when (length line /= 3) $ do
      fail "blockTraits requires two '|'"
    let topRight = line !! 0 
        botLeft  = line !! 1
        botRight = line !! 2
    return BlockTraits {..}

parseBlock :: Parser Block
parseBlock = do
  blockTitle  <- string "###" *> hspace *> parseChars 
  newline
  blockTraits <- parseBlockTraits
  return Block {..}

parseLine :: Parser Line
parseLine = do
  section <- parseSection
  return $ S section

-- many "\n" inefficient?
parseResume :: Parser Resume
parseResume = do
  intro <- parseIntro
  many "\n"
  sec   <- fmap S parseSection
  newline
  block <- fmap B parseBlock  
  let lines = [sec, block]
  return Resume {..}


