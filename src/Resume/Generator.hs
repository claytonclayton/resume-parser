{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
 
module Resume.Generator 
  ( generateResume
  , printResumes
  ) where

import Resume.Parser 
  ( Intro(Intro)
  , Section(Section)
  , Block
    ( Block
    )
  , SubBlock(SubBlock)
  , Dot(Dot)
  , Flat(Flat)
  , BlockTraits
    (topLeft
    , topRight
    , botLeft
    , botRight
    )
  ) 

import Resume.Grouper 
  ( ResumeGroup
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
  show (ResumeTex ls) = 
    T.unpack $ T.unlines ls

type DList = [Text] -> [Text]

link :: [a] -> (a -> DList) -> DList
link as f = foldl (.) id $ f <$> as 

tabSize :: Int
tabSize = 4

tabber :: Int -> Text
tabber i = T.pack $ take (i * tabSize) $ repeat ' ' 

prefixPath, texPath :: String
prefixPath = "me/pipeline/tex/prefix.tex"
texPath    = "me/pipeline/tex/resume.tex"

printResumes :: ResumeGroup -> IO ()
printResumes r = do
  prefix <- readFile prefixPath 
  let tex = generateResume r
      out = prefix <> show tex
  writeFile texPath out
  putStrLn out 

generateResume :: ResumeGroup -> ResumeTex
generateResume r = ResumeTex
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

-- test empty traits
generateIntro :: Intro -> DList
generateIntro (Intro ti ts)
  = ("\\begin{center}" :)
  . (tabber 1 <> "\\ResumeTitle{" <> ti <> "}" :)
  . case ts of 
      [] -> id
      _  -> (tabber 1 <> "\\small " <> (T.intercalate " $|$ " . fmap underline) ts :) 
  . ("\\end{center}" :)
  . ("":)
  where 
    underline t
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
  . ("":)
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

