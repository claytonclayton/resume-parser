
module Cli (main) where

import Resume.Render
  ( executeRenderFile
  , cliConfig
  )

import System.Environment (getArgs)

-- should test if input path is a valid file too
main :: IO ()
main = do
  args <- getArgs
  case args of
    [ ] -> executeRenderFile cliConfig Nothing
    [x] -> executeRenderFile cliConfig $ Just x
    _   -> print "error: Cli.hs expects 0-1 arguments"
