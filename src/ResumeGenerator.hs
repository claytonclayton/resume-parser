{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
 
module ResumeGenerator (generateTex) where

import ResumeParser (ResumeADT(ResumeADT), Intro, Section(Section), Block(Block), SubBlock(SubBlock), Dot(Dot), Flat(Flat), Line(B, SB, S, F, D, I)) 
import Data.Text (Text)
import qualified Data.Text as T

type ResumeTex = [Text]

generateTex :: ResumeADT -> ResumeTex
generateTex (ResumeADT lines) =
  fmap convertLine lines 

convertLine :: Line -> Text
convertLine l = 
  case l of
    (D d)  -> convertDot d
    (S s)  -> convertSection s
    (I i)  -> convertIntro i 
    (SB b) -> convertSubBlock b 
    (F f)  -> convertFlat f 
    (B b)  -> convertBlock b 


convertDot :: Dot -> Text
convertDot (Dot d) = "\\Dot{" <> d <> "}"

convertSection :: Section -> Text
convertSection (Section s) = "\\section{" <> s <> "}"

convertIntro :: Intro -> Text
convertIntro = undefined

convertSubBlock :: SubBlock -> Text
convertSubBlock = undefined

convertFlat :: Flat -> Text
convertFlat = undefined

convertBlock :: Block -> Text
convertBlock = undefined
