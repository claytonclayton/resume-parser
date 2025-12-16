
module Main (main) where

import Text.Megaparsec (parseTest)
import Lib (parseResume)
import qualified Data.Text.IO as T

main :: IO ()
main = do
  md <- T.readFile "resume.md"
  parseTest parseResume md
