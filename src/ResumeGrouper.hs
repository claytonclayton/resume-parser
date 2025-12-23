{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
 
module ResumeGrouper (groupResumes) where

import ResumeParser (ResumeADT(ResumeADT), Intro, Section(Section, sectionTitle), Block(Block), SubBlock(SubBlock), Dot(Dot), Flat(Flat), Line(PosSection, PosSubBlock, PosBlock, PosDot, PosFlat, PosIntro), Positioned(getPos, getValue)) 
import Data.Text (Text)
import qualified Data.Text as T
import Control.Monad (when)

data ResumeAST = ResumeAST
  { intro    :: Maybe Intro
  , sections :: [SectionAST]
  } 
  deriving (Show, Eq)

data SectionAST = SectionAST
  { section :: Section
  , blocks  :: [BlockAST] 
  } 
  deriving (Show, Eq)

data BlockAST = BlockAST
  { block :: Block
  , lines :: [LineAST]
  }
  deriving (Show, Eq)
 
data LineAST = Ff Flat | Dd Dot | Sb SubBlock
  deriving (Show, Eq)

data GroupError
  = DotOutsideBlock
  | FlatOutsideBlock
  | SubBlockOutsideBlock
  | SomethingOutsideBlock -- should never occur
  | RemainingLines
  deriving (Show, Eq)

groupResumes :: ResumeADT -> Either GroupError ([Line], [ResumeAST])
groupResumes (ResumeADT ls) = groupResumes' ls

groupResumes' :: [Line] -> Either GroupError ([Line], [ResumeAST])
groupResumes' ls = do
  case ls of
    (PosIntro i : ls)   -> ret ls $ Just $ getValue i
    (PosSection s : ls) -> ret ls Nothing
    ls -> return (ls, [])
  where 
    ret ls intro = do
      dotCheck ls
      (rem1, sections) <- groupSections ls
      (rem2, res)      <- groupResumes' rem1
      when (length rem2 /= 0) $ Left RemainingLines 
      return (rem2, ResumeAST intro sections : res)
  
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
groupSections ls = Right (ls, []) 
  
groupBlocks :: [Line] -> Either GroupError ([Line], [BlockAST])
groupBlocks (PosBlock b : ls) = do
  let block = getValue b 
  (rem1, lines)  <- groupLines ls 
  (rem2, blocks) <- groupBlocks rem1
  return (rem2, BlockAST block lines : blocks)
groupBlocks [] = Right ([], []) 
groupBlocks ls = Right (ls, []) 

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
groupLines ls = Right (ls, [])

