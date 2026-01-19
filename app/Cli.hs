
module Cli (main) where

import Resume.Render
  ( executeRender
  )

import System.Environment (getArgs)

-- should test if input path is a valid file too
main :: IO ()
main = do
  args <- getArgs
  case args of
    []  -> executeRender Nothing
    [x] -> executeRender $ Just x
    _   -> print "error: Cli.hs expects 0-1 arguments"
