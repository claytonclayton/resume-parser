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

data GroupError
  = DotOutsideBlock
  | FlatOutsideBlock
  | SubBlockOutsideBlock

groupResume :: ResumeADT -> ResumeAST
groupResume = undefined

dotCheck :: [Line] -> Either GroupError ()
dotCheck (PosDot d : ls)      = Left DotOutsideBlock
dotCheck (PosFlat f : ls)     = Left FlatOutsideBlock
dotCheck (PosSubBlock s : ls) = Left SubBlockOutsideBlock
dotCheck _ = Right ()

groupSections :: [Line] -> Either GroupError ([Line], [SectionAST])
groupSections (PosSection s : ls) = do
  dotCheck ls
  let section = getValue s
  (rem1, blocks)   <- groupBlocks ls 
  (rem2, sections) <- groupSections rem1
  return (rem2, SectionAST section blocks : sections)
groupSections [] = Right ([], []) 
groupSections _  = Right ([], []) 
  
groupBlocks :: [Line] -> Either GroupError ([Line], [BlockAST])
groupBlocks (PosBlock b : ls) = do
  let block = getValue b 
  (rem1, lines)  <- groupLines ls 
  (rem2, blocks) <- groupBlocks rem1
  return (rem2, BlockAST block lines : blocks)
groupBlocks [] = Right ([], []) 
groupBlocks _ =  Right ([], []) 

groupLines :: [Line] -> Either GroupError ([Line], [LineAST])
groupLines (PosDot d : ls) = do
  let dot = getValue d
  (rem, lines) <- groupLines ls
  return (rem, Dd dot : lines) 
groupLines (PosFlat f : ls) = do
  let flat = getValue f 
  (rem, lines) <- groupLines ls
  return (rem, Ff flat: lines) 
groupLines (PosSubBlock sb : ls) = do
  let subBlock = getValue sb 
  (rem, lines) <- groupLines ls
  return (rem, Sb subBlock : lines) 
groupLines [] = Right ([], [])
groupLines _  = Right ([], [])
