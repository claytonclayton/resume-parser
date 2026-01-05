{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
 
module ResumeGrouper 
  ( groupResumes
  , ResumeGroup
  , Minor
    ( Fs
    , Ds
    , Sb
    , Bb
    )
  ) 
  where

import ResumeParser 
  ( ResumeADT(ResumeADT)
  , Intro
  , Section(Section
  , sectionTitle)
  , Block(Block)
  , BlockTraits
    (topLeft
    , topRight
    , botLeft
    , botRight
    )
  , SubBlock(SubBlock)
  , Dot(Dot)
  , Flat(Flat)
  , Line
    (PosSection
    , PosSubBlock
    , PosBlock
    , PosDot
    , PosFlat
    , PosIntro
    )
  , Positioned(getPos, getValue)
  ) 

import Text.Megaparsec hiding (State)
import Data.Text (Text)
import qualified Data.Text as T
import Control.Monad (when)

type ResumeGroup = [Major]

data Major = Ss Section [Minor] | Ii Intro
  deriving (Show, Eq)

data Minor = Fs [Flat] | Ds [Dot] | Sb SubBlock | Bb Block
  deriving (Show, Eq)

data GroupError
  = MinorOutsideMajor Line
  | RemainingLines    Line
  deriving (Show, Eq)

type GroupResult a = Either GroupError ([Line], a)

groupResumes :: ResumeADT -> Either GroupError ([Line], ResumeGroup)
groupResumes (ResumeADT ls) = groupResumes' ls

groupResumes' :: [Line] -> GroupResult ResumeGroup
groupResumes' (PosIntro i : ls) = do
  (ls', res) <- groupResumes' ls 
  return (ls', (Ii $ getValue i) : res)
groupResumes' (PosSection s : ls) = do
  (rem1, mis) <- groupMinors ls 
  (rem2, res) <- groupResumes' rem1 
  return (rem2, (Ss (getValue s) mis) : res)
groupResumes' (l:ls) = Left $ MinorOutsideMajor l

groupMinors :: [Line] -> GroupResult [Minor]
groupMinors (PosDot d : ls) = do
  (rem1, dots) <- groupDots (PosDot d : ls)
  (rem2, res)  <- groupMinors rem1 
  return (rem2, Ds dots : res)
groupMinors (PosFlat f : ls) = do
  (rem1, flats) <- groupFlats (PosFlat f: ls)
  (rem2, res)   <- groupMinors rem1 
  return (rem2, Fs flats : res)
groupMinors (PosBlock b : ls) = do
  (ls', res) <- groupMinors ls
  return (ls', (Bb $ getValue b) : res)
groupMinors (PosSubBlock sb : ls) = do
  (ls', res) <- groupMinors ls
  return (ls', (Sb $ getValue sb) : res)
  
groupDots :: [Line] -> GroupResult [Dot]
groupDots (PosDot d : ls) = do
  (ls', dots) <- groupDots ls 
  return (ls', (getValue d) : dots) 
groupDots ls = return (ls, [])

groupFlats :: [Line] -> GroupResult [Flat]
groupFlats (PosFlat f : ls) = do
  (ls', flats) <- groupFlats ls 
  return (ls', (getValue f) : flats) 
groupFlats ls = return (ls, [])
  
-- groupResumes' :: [Line] -> Either GroupError ([Line], [ResumeGroup])
-- groupResumes' ls = do
--   case ls of
--     (PosIntro i : ls)   -> ret ls $ Just $ getValue i
--     (PosSection s : ls) -> ret ls Nothing
--     ls -> return (ls, [])
--   where 
--     ret ls intro = do
--       dotCheck ls
--       (rem1, sections) <- groupSections ls
--       (rem2, res)      <- groupResumes' rem1
--       when (length rem2 /= 0) $ Left RemainingLines
--       return (rem2, ResumeGroup intro sections : res)
--   
-- dotCheck :: [Line] -> Either GroupError ()
-- dotCheck (PosDot d : ls)      = Left DotOutsideBlock
-- dotCheck (PosFlat f : ls)     = Left FlatOutsideBlock
-- dotCheck (PosSubBlock s : ls) = Left SubBlockOutsideBlock
-- dotCheck _ = Right ()
-- 
-- -- consider rewriting with State monad
-- groupSections :: [Line] -> Either GroupError ([Line], [SectionGroup])
-- groupSections (PosSection s : ls) = do
--   dotCheck ls
--   let section = getValue s
--   (rem1, blocks)   <- groupBlocks ls 
--   (rem2, sections) <- groupSections rem1
--   return (rem2, SectionGroup section blocks : sections)
-- groupSections ls = Right (ls, []) 
--   
-- groupBlocks :: [Line] -> Either GroupError ([Line], [BlockAST])
-- groupBlocks (PosBlock b : ls) = do
--   let block = getValue b 
--   (rem1, lines)  <- groupLines ls 
--   (rem2, blocks) <- groupBlocks rem1
--   return (rem2, BlockAST block lines : blocks)
-- groupBlocks ls = Right (ls, []) 
-- 
-- groupLines :: [Line] -> Either GroupError ([Line], [LineAST])
-- groupLines (PosDot d : ls) = do
--   let dot = getValue d
--   (rem, lines) <- groupLines ls
--   return (rem, Dd dot : lines) 
-- groupLines (PosFlat f : ls) = do
--   let flat = getValue f 
--   (rem, lines) <- groupLines ls
--   return (rem, Ff flat: lines) 
-- groupLines (PosSubBlock sb : ls) = do
--   let subBlock = getValue sb 
--   (rem, lines) <- groupLines ls
--   return (rem, Sb subBlock : lines) 
-- groupLines ls = Right (ls, [])

