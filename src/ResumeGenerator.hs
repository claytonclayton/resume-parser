{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
 
module ResumeGenerator (generateResumes) where

import ResumeParser (ResumeADT(ResumeADT), Intro, Section(Section), Block(Block, blockTitle, blockTraits), SubBlock(SubBlock), Dot(Dot), Flat(Flat), Line(PosSection, PosSubBlock, PosBlock, PosDot, PosFlat, PosIntro), BlockTraits(topLeft, topRight, botLeft, botRight)) 
import ResumeGrouper (ResumeAST(ResumeAST), SectionAST(SectionAST), BlockAST(BlockAST), LineAST(Ff, Dd, Sb))
import Data.Text (Text)
import qualified Data.Text as T

data ResumeTex = ResumeTex [Text]
  deriving (Eq)

instance Show ResumeTex where
  show (ResumeTex lines) = 
    T.unpack $ T.unlines lines 

link :: [a] -> (a -> [Text] -> [Text]) -> [Text] -> [Text]
link as f = foldl (.) id $ f <$> as 

tabSize :: Int
tabSize = 4

tabber :: Int -> Text
tabber i = T.pack $ take (i * tabSize) $ repeat ' ' 

generateResumes :: [ResumeAST] -> ResumeTex
generateResumes rs = ResumeTex $ link rs generateResume []
 
generateResume :: ResumeAST -> [Text] -> [Text]
generateResume (ResumeAST i ss)
  = (generateIntro i) 
  . (link ss generateSection)

generateIntro :: Maybe Intro -> [Text] -> [Text]
generateIntro i = ("":) 

generateSection :: SectionAST -> [Text] -> [Text]
generateSection (SectionAST (Section s) bs) 
  = ("\\section{" <> s <> "}" :) 
  . ("\\SectionStart" :) 
  . (link bs generateBlock) 
  . ("\\SectionEnd" :)
  . ("" :)

generateBlock :: BlockAST -> [Text] -> [Text]
generateBlock (BlockAST b ls) = 
  let title  = blockTitle b
      traits = blockTraits b 
      tl     = topLeft traits
      tr     = topRight traits
      bl     = botLeft traits
      br     = botRight traits
  in (tabber 1 <> "\\Block" :)
   . (tabber 2 <> "{" <> title <> "}[" <> tl <> "][" <> tr <> "][" <> bl <> "][" <> br <> "]":)
   . (generateLines ls)

generateLines :: [LineAST] -> [Text] -> [Text]
generateLines ls = ("":) 

