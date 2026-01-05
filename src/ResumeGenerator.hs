{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
 
module ResumeGenerator 
  ( generateResumes
  , printResumes
  ) where

import ResumeParser 
  ( ResumeADT (ResumeADT)
  , Intro(Intro)
  , Section(Section)
  , Block
    ( Block
    , blockTitle
    , blockTraits
    )
  , SubBlock(SubBlock)
  , Dot(Dot)
  , Flat(Flat)
  , Line
    ( PosSection
    , PosSubBlock
    , PosBlock
    , PosDot
    , PosFlat
    , PosIntro
    )
  , BlockTraits
    (topLeft
    , topRight
    , botLeft
    , botRight
    )
  ) 
import ResumeGrouper 
  ( groupResumes
  , ResumeGroup
  , Major
    ( Ii
    , Ss
    )
  , Minor
    ( Bb
    , Sb
    , Ds
    , Fs
    )
  )

import Data.Text (Text)
import qualified Data.Text as T

data ResumeTex = ResumeTex [Text]
  deriving (Eq)

instance Show ResumeTex where
  show (ResumeTex lines) = 
    T.unpack $ T.unlines lines 

type DList = [Text] -> [Text]

link :: [a] -> (a -> DList) -> DList
link as f = foldl (.) id $ f <$> as 

tabSize :: Int
tabSize = 4

tabber :: Int -> Text
tabber i = T.pack $ take (i * tabSize) $ repeat ' ' 

prefixFilename :: String
prefixFilename = "prefix.tex"

outFilename :: String
outFilename = "out.tex"

printResumes :: ResumeGroup -> IO ()
printResumes r = do
  prefix <- readFile prefixFilename 
  let tex = generateResumes r
      out = prefix <> show tex
  writeFile  outFilename out
  putStrLn out 

generateResumes :: ResumeGroup -> ResumeTex
generateResumes r = ResumeTex
  $ ("\\begin{document}" :)
  . ("":)
  . (link r generateMajor) 
  . ("\\end{document}" :)
  . ("":)
  $ []
  
generateMajor :: Major -> DList
generateMajor (Ii intro) 
  = generateIntro intro 
generateMajor (Ss (Section s) mis) 
  = ("\\section{" <> s <> "}" :) 
  . ("\\SectionStart" :) 
  . (link mis generateMinor) 
  . ("\\SectionEnd" :)
  . ("" :)

generateIntro :: Intro -> DList
generateIntro (Intro ti (t:ts))
  = ("\\begin{center}" :)
  . (tabber 1 <> "\\ResumeTitle{" <> ti <> "}" :)
  . (tabber 1 <> "\\small" <> foldl (\a b -> (a <> " $|$ " <> process b)) t ts :) -- check foldr / foldl efficiency
  . ("\\end{center}" :)
  . ("":)
  where 
    process t
      | any (`T.isInfixOf` t) ["@", "/"] = "\\underline{\\url{" <> t <> "}}" -- doesn't work with emails currently
      | otherwise = t

generateMinor :: Minor -> DList
generateMinor (Bb b)  
  = generateBlock b
generateMinor (Sb (SubBlock l r)) 
  = (tabber 1 <> "\\SubBlock{" <> l <> "}" <> "[" <> r <> "]" :)
generateMinor (Ds ds)
  = (tabber 1 <> "\\DotStart" :)   
  . (link ds generateDot)
  . (tabber 1 <> "\\DotEnd" :)
  . ("":)
  where
    generateDot (Dot d) = (tabber 2 <> "\\Dot{" <> d <> "}" :) 
generateMinor (Fs fs)
  = (tabber 1 <> "\\FlatStart" :) 
  . (link fs generateFlat)
  . (tabber 1 <> "\\FlatEnd" :)
  where
    generateFlat (Flat ti re) = (tabber 2 <> "\\Flat{" <> ti <> "}[" <> re <> "]" :) 

generateBlock :: Block -> DList
generateBlock (Block title traits) = 
  let tl = topLeft traits
      tr = topRight traits
      bl = botLeft traits
      br = botRight traits
  in (tabber 1 <> "\\Block" :)
   . (tabber 2 <> "{" <> title <> "}[" <> tl <> "][" <> tr <> "][" <> bl <> "][" <> br <> "]":)

