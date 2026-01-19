{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
 
module Resume.Grouper 
  ( groupResume
  , ResumeGroup
  , GroupError
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
  | RemainingLines
  deriving (Show, Eq)

type GroupResult a = Either GroupError ([Line], a)

-- add back RemainingLines error
groupResume :: Resume -> Either GroupError ResumeGroup
groupResume (Resume ls) = do
  (ls', res) <- groupResume' ls
  Right res
  --case ls' of
  --  [] -> Left RemainingLines -- should include what lines were not included
  --  _  -> Right res

groupResume' :: [Line] -> GroupResult ResumeGroup
groupResume' (Line _ (I i) : ls) = 
  (fmap . fmap) (Ii i :) (groupResume' ls)
groupResume' (Line _ (S s) : ls) = do
  (rem1, mis) <- groupMinors ls
  (rem2, res) <- groupResume' rem1 
  return (rem2, (Ss s mis) : res)
--groupResume' (l:ls) = Left $ MinorOutsideMajor l
groupResume' ls = return (ls, [])

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
      return (Line p l : ls, [])
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
