{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
 
module ResumeGenerator (generateResume) where

import ResumeParser (ResumeADT(ResumeADT), Intro, Section(Section), Block(Block), SubBlock(SubBlock), Dot(Dot), Flat(Flat), Line(PosSection, PosSubBlock, PosBlock, PosDot, PosFlat, PosIntro)) 
import ResumeGrouper (ResumeAST(ResumeAST), SectionAST(SectionAST), BlockAST(BlockAST))
import Data.Text (Text)
import qualified Data.Text as T

data ResumeTex = ResumeTex [Text]
  deriving (Eq)

-- instance Show ResumeTex where
--   show (ResumeTex lines) = 
--     T.unpack $ T.unlines lines 

generateResume :: ResumeAST -> ResumeTex
generateResume (ResumeAST i s) = undefined

generateIntro :: Maybe Intro -> [Text] -> [Text]
generateIntro i = ("":) 

generateSection :: SectionAST -> [Text] -> [Text]
generateSection (SectionAST (Section s) bs) 
  = ("\\section{" <> s <> "}" :) 
  . ("\\SectionStart" :) 
  . (generateBlocks bs) 
  . ("\\SectionEnd":)

generateBlocks :: [BlockAST] -> [Text] -> [Text]
generateBlocks = undefined

generateBlock :: Block -> Text
generateBlock b = ""

generateDot :: Dot -> Text
generateDot (Dot d) = "\\Dot{" <> d <> "}"

generateSubBlock :: SubBlock -> Text
generateSubBlock b = ""

generateFlat :: Flat -> Text
generateFlat f = ""

