{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
 
module ResumeGenerator (generateTex) where

import ResumeParser (ResumeADT(ResumeADT), Intro, Section(Section), Block(Block), SubBlock(SubBlock), Dot(Dot), Flat(Flat), Line(B, SB, S, F, D, I)) 
import Data.Text (Text)
import qualified Data.Text as T

data ResumeTex = ResumeTex [Text]
  deriving (Eq)

-- better to write a separate function that outputs Text rather than String
instance Show ResumeTex where
  show (ResumeTex lines) = 
    T.unpack $ T.unlines lines 

generateTex :: ResumeADT -> ResumeTex
generateTex (ResumeADT lines) =
  ResumeTex $ fmap convertLine lines 

convertLine :: Line -> Text
convertLine l = 
  case l of
    (D d)  -> convertDot d
    (S s)  -> convertSection s
    (I i)  -> convertIntro i 
    (SB b) -> convertSubBlock b 
    (F f)  -> convertFlat f 
    (B b)  -> convertBlock b 

convertLines :: [Line] -> [Text]
convertLines []     = []
convertLines (l:ls) = 
  case l of
    (D d)  -> convertDot' d ls

convertDot :: Dot -> Text
convertDot (Dot d) = "\\Dot{" <> d <> "}"

convertDot' :: Dot -> [Line] -> [Text]
convertDot' (Dot d) []     = []
convertDot' (Dot d) (l:ls) = 
  let rest = 
        case l of
          (D _) -> convertLines (l:ls)
          _     -> ("\\DotEnd"):(convertLines (l:ls))
  in ("\\Dot{" <> d <> "}"):rest


convertSection :: Section -> Text
convertSection (Section s) = "\\section{" <> s <> "}"

convertIntro :: Intro -> Text
convertIntro i = ""

convertSubBlock :: SubBlock -> Text
convertSubBlock b = ""

convertFlat :: Flat -> Text
convertFlat f = ""

convertBlock :: Block -> Text
convertBlock b = ""
