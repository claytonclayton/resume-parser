
module Main (main) where

import Text.Megaparsec (runParser, errorBundlePretty)
import ResumeParser  (parseResume)
import ResumeGrouper (groupResumes, ResumeGroup)
import ResumeGenerator (generateResumes, printResumes)
import System.Environment (getArgs)
import qualified Data.Text.IO as TIO
import qualified Data.Text as T
import qualified Data.Text.Lazy.Builder as B
import Data.Text.Lazy (toStrict)
import Data.Text (Text)

defaultInFileName = "me/pipeline/md/resume.md"

-- Move to another file
-- escaper is NAIVE
-- should check whether the escapees are already escaped
-- or not before escaping
linter :: Text -> Text
linter = toStrict . B.toLazyText . T.foldr escaper mempty . stripper
  where
    stripper = T.unlines . fmap T.strip . T.lines
    escaper c
      | c `elem` escapees = (<>) $ B.singleton '\\' <> B.singleton c 
      | otherwise         = (<>) $ B.singleton c
    escapees = ['&', '$']

main :: IO ()
main = do
  args <- getArgs
  let inFileName 
        = case args of
            []   -> defaultInFileName
            x:xs -> x 

  md   <- TIO.readFile inFileName

  let parseOut = runParser parseResume "" $ linter md 

  case parseOut of 
    Left  bundle -> putStr $ errorBundlePretty bundle
    Right adt    -> 
      case groupResumes adt of
        Left ge         -> print ge
        Right (ls, ast) -> printResumes ast


