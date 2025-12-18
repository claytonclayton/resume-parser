
module ResumeGenerator () where

import ResumeParser (ResumeADT, Intro, Section, Block, SubBlock, Dot, Flat) 
import Data.Text (Text)
import qualified Data.Text as T

data ResumeTex = ResumeTex [Text]
