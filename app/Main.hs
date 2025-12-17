
module Main (main) where

import Text.Megaparsec (parseTest)
import Lib (parseResume)
import qualified Data.Text.IO as TIO
import qualified Data.Text as T

main :: IO ()
main = do
  md <- TIO.readFile "resume.md"
  let lint = T.unlines $ fmap T.strip $ T.lines md
  parseTest parseResume lint
