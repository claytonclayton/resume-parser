
module Cli (main) where

import Resume.Parser  
  ( parseResume
  )

import Resume.Grouper 
  ( groupResumes
  , ResumeGroup
  )

import Resume.Generator 
  ( generateResumes
  , printResumes
  )

import Resume.Preprocessor
  ( preprocess
  ) 

import Text.Megaparsec (runParser, errorBundlePretty)
import System.Environment (getArgs)
import qualified Data.Text.IO as TIO
import qualified Data.Text as T
import qualified Data.Text.Lazy.Builder as B
import Data.Text.Lazy (toStrict)
import Data.Text (Text)

defaultInFileName = "me/md/resume.md"

main :: IO ()
main = do
  args <- getArgs
  let inFileName 
        = case args of
            []   -> defaultInFileName
            x:xs -> x 

  md   <- TIO.readFile inFileName

  let parseOut = runParser parseResume "" $ preprocess md 

  -- fix this abomination
  case parseOut of 
    Left  bundle -> putStr $ errorBundlePretty bundle
    Right adt    -> 
      case groupResumes adt of
        Left ge         -> print ge
        Right (ls, ast) -> printResumes ast



