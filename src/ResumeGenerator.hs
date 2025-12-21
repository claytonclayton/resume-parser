{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
 
module ResumeGenerator () where

import ResumeParser (ResumeADT(ResumeADT), Intro, Section(Section), Block(Block), SubBlock(SubBlock), Dot(Dot), Flat(Flat), Line(B, SB, S, F, D, I)) 
import Data.Text (Text)
import qualified Data.Text as T

type ResumeTex = [Text]

generateTex :: ResumeADT -> ResumeTex
generateTex (ResumeADT intro lines) =
  fmap convertLine lines 

convertLine :: Line -> Text
convertLine l = 
  case l of
    (D d)  -> convertDot d
    (S s)  -> undefined

convertDot :: Dot -> Text
convertDot (Dot d) = "\\Dot{" <> d <> "}"

