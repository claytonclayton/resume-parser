{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Lib (Resume, Intro, Block, Flat, Line, Parser, parser) where

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

data Line = Section Text | B Block | Dot Text | F Flat
  deriving (Eq, Show)

type Parser = Parsec Void Text

parser :: Parser Intro
parser = do 
  title  <- fmap T.pack $ char '#' *> hspace *> some alphaNumChar <* hspace
  newline
  traits <- (fmap . fmap) T.pack $ (hspace *> many alphaNumChar <* hspace) `sepBy` "|" 
  return Intro {..}


  
