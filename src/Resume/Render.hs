
module Resume.Render (executeRender) where

import Resume.Parser  
  ( parseResume
  )

import Resume.Grouper 
  ( groupResume
  , ResumeGroup
  , GroupError
  )

import Resume.Generator 
  ( generateResume
  , printResumes
  )

import Resume.Preprocessor
  ( preprocess
  ) 

import Text.Megaparsec 
import System.Environment (getArgs)
import qualified Data.Text.IO as TIO
import qualified Data.Text as T
import qualified Data.Text.Lazy.Builder as B
import Data.Text.Lazy (toStrict)
import Data.Text (Text)
import Data.Maybe
import Data.Bifunctor
import Data.Void
import Control.Monad.Trans.Except
import Control.Monad.Trans.Maybe
import Control.Monad.Trans
import Control.Monad

import System.Process
import System.Exit

defaultMdPath = "me/md/resume.md"
texPath = "me/pipeline/tex/resume.tex"
outPath = "me/pipeline/pdf"
auxPath = "me/aux"
prefixPath = "me/pipeline/tex/prefix.tex"

data RenderError
  = PErr (ParseErrorBundle Text Void)
  | GErr GroupError
  | ExitCode Int
  deriving (Show)

-- maybe convert to simply Either and move effects elsewhere
transpile :: Text -> ExceptT RenderError IO ()
transpile md = do
  lines  <- except $ first PErr $ runParser parseResume "" $ preprocess md
  groups <- except $ first GErr $ groupResume lines
  prefix <- lift $ readFile prefixPath
  let tex = (<>) prefix $ show $ generateResume groups
  lift $ writeFile texPath tex

render :: Maybe FilePath -> ExceptT RenderError IO ()
render mdPath = do
  md  <- lift $ TIO.readFile $ fromMaybe defaultMdPath mdPath
  res <- transpile md   

  let 
    args =
      [ "-pdf"
      , "-auxdir=" ++ auxPath
      , "-outdir=" ++ outPath
      , texPath
      ]

  (_, _, _, ph) <- lift $ createProcess (proc "latexmk" args)
  exitCode      <- lift $ waitForProcess ph

  case exitCode of
    ExitSuccess   -> pure ()
    ExitFailure c -> throwE $ ExitCode c

executeRender :: Maybe FilePath -> IO ()
executeRender mPath = do
  result <- runExceptT (render mPath)
  case result of
    Left err -> print err
    Right _  -> return ()
