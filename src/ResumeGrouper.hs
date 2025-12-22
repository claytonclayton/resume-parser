{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
 
module ResumeGrouper () where

import ResumeParser (ResumeADT(ResumeADT), Intro, Section(Section, sectionTitle), Block(Block), SubBlock(SubBlock), Dot(Dot), Flat(Flat), Line(PosSection, PosSubBlock, PosBlock, PosDot, PosFlat, PosIntro), Positioned(getPos, getValue)) 

import Data.Text (Text)
import qualified Data.Text as T

data ResumeAST = ResumeAST
  { intro    :: Intro
  , sections :: [SectionAST]
  } 

data SectionAST = SectionAST
  { section :: Section
  , blocks  :: [BlockAST] } 

data BlockAST = BlockAST
  { block :: Block
  , lines :: [LineAST]
  }
 
data LineAST = Ff Flat | Dd Dot | Sb SubBlock

data GroupError = GroupError

groupResume :: ResumeADT -> ResumeAST
groupResume = undefined

groupLines :: [Line] -> Either GroupError ([Line], [LineAST])
groupLines [] = undefined 
groupDots (l:ls) = undefined
  
groupSections :: [Line] -> Either GroupError ([Line], [SectionAST])
groupSections [] = Right $ ([], []) 
groupSections (PosSection s : ls) = do
  let section = getValue s
  (rem1, blocks)   <- groupBlocks ls 
  (rem2, sections) <- groupSections rem1
  return (rem2, SectionAST section blocks : sections)
  
groupBlocks :: [Line] -> Either GroupError ([Line], [BlockAST])
groupBlocks = undefined

