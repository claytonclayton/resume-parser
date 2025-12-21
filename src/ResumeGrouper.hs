{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
 
module ResumeGrouper () where

import ResumeParser (ResumeADT(ResumeADT), Intro, Section(Section), Block(Block), SubBlock(SubBlock), Dot(Dot), Flat(Flat), Line(B, SB, S, F, D, I)) 
import Data.Text (Text)
import qualified Data.Text as T

data ResumeAST = ResumeAST
  { intro    :: Intro
  , sections :: [SectionAST]
  } 

data SectionAST = SectionAST
  { sectionTitle :: Text
  , blocks       :: [BlockAST] } 

data BlockAST = BlockAST
  { block :: Block
  , lines :: [LineAST]
  }
 
data LineAST = Ff Flat | Dd Dot | Sb SubBlock

groupResume :: ResumeADT -> ResumeAST
groupResume = undefined
