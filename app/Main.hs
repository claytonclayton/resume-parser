
module Main (main) where

import Text.Megaparsec (runParser, errorBundlePretty)
import ResumeParser  (parseResume)
import ResumeGrouper (groupResumes, ResumeGroup)
import ResumeGenerator (generateResumes, printResumes)
import qualified Data.Text.IO as TIO
import qualified Data.Text as T

main :: IO ()
main = do
  md <- TIO.readFile "resume.md"
  let lint     = T.unlines $ fmap T.strip $ T.lines md
      parseOut = runParser parseResume "" lint
  case parseOut of 
    Left  bundle -> putStr $ errorBundlePretty bundle
    Right adt    -> 
      case groupResumes adt of
        Left ge         -> print ge
        Right (ls, ast) -> printResumes ast


