{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
 
module Resume.Grouper 
  ( groupResumes
  , ResumeGroup
  , Minor
    ( Fs
    , Ds
    , Sb
    , Bb
    )
  , Major
    ( Ii
    , Ss
    ) 
  ) 
  where

import Resume.Parser 
  ( Resume(Resume)
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
    ( Line
    , getPos
    , getVal
    )
  , Element
    ( I
    , S
    , SB
    , B
    , D
    , F
    )
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

groupResumes :: Resume -> GroupResult ResumeGroup
groupResumes (Resume ls) = groupResumes' ls

groupResumes' :: [Line] -> GroupResult ResumeGroup
groupResumes' (Line _ (I i) : ls) = 
  (fmap . fmap) (Ii i :) (groupResumes' ls)
groupResumes' (Line _ (S s) : ls) = do
  (rem1, mis) <- groupMinors ls 
  (rem2, res) <- groupResumes' rem1 
  return (rem2, (Ss s mis) : res)
groupResumes' (l:ls) = Left $ MinorOutsideMajor l
groupResumes' ls = return (ls, [])

groupMinors :: [Line] -> GroupResult [Minor]
groupMinors (Line p l : ls) =
  case l of
    D _  -> do
      (rem1, dots) <- groupDots (Line p l : ls)
      (rem2, res)  <- groupMinors rem1 
      return (rem2, Ds dots : res)
    F _  -> do
      (rem1, flats) <- groupFlats (Line p l : ls)
      (rem2, res)   <- groupMinors rem1 
      return (rem2, Fs flats : res)
    B b  ->
      (fmap . fmap) (Bb b :) (groupMinors ls)
    SB s ->
      (fmap . fmap) (Sb s :) (groupMinors ls)
    _    -> 
      return (ls, [])
groupMinors ls = return (ls, [])

--groupRest :: a -> [Line] -> ([Line] -> GroupResult [a]) -> [Line] -> GroupResult [a]
--groupRest x ls f = (fmap . fmap) (x :) (f ls)

groupDots :: [Line] -> GroupResult [Dot]
groupDots (Line _ (D d) : ls) = do
  (fmap . fmap) (d :) (groupDots ls)
groupDots ls = return (ls, [])

groupFlats :: [Line] -> GroupResult [Flat]
groupFlats (Line _ (F f) : ls) = do
  (fmap . fmap) (f :) (groupFlats ls)
groupFlats ls = return (ls, [])
