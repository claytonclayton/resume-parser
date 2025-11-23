{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Lib (Resume, Intro, Block, Flat, Line, Parser) where

import Data.Char (isAlphaNum)
import Data.Text (Text)
import Data.Void
import Text.Megaparsec hiding (State)
import Text.Megaparsec.Char
import qualified Data.Text as T

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

data Block = Block
  { blockTitle :: Text
  , topRight   :: Maybe Text
  , botLeft    :: Maybe Text 
  , botRight   :: Maybe Text
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

parseNot :: Char -> Parser Text
parseNot c = 
  takeWhileP Nothing (\x -> x /= c && x /= '\n') 

parseLine :: Parser Text
parseLine = 
  takeWhile1P Nothing (/= '\n') 

parseSep :: Char -> Parser [Text]
parseSep c = 
  (fmap . fmap) T.strip $ (parseNot '|') `sepBy` char c 

