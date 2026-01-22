
module Resume.Render 
  ( render
  , executeRender
  , executeTranspile
  ) where

import Resume.Parser  
  ( parseResume
  )

import Resume.Grouper 
  ( groupResume
  , GroupError
  )

import Resume.Generator 
  ( generateResume
  )

import Resume.Preprocessor
  ( preprocess
  ) 

import Text.Megaparsec 
import qualified Data.Text.IO as TIO
import qualified Data.Text as T
import Data.Text (Text)
import Data.Maybe
import Data.Bifunctor
import Data.Void
import Control.Monad.Trans.Except
import Control.Monad.Trans

import System.Process
import System.Exit

defaultMdPath, texPath, outPath, auxPath, prefixPath  :: String
defaultMdPath = "me/md/resume.md"
texPath = "me/pipeline/tex/resume.tex"
outPath = "me/pipeline/pdf"
auxPath = "me/aux"
prefixPath = "me/pipeline/tex/prefix.tex"

data RenderError
  = PErr (ParseErrorBundle Text Void)
  | GErr GroupError
  | ExitCode Int

instance Show RenderError where
  show (PErr p) = errorBundlePretty p
  show (GErr g) = show g
  show (ExitCode i) = "exit code: " <> show i 

-- maybe convert to simply Either and move effects elsewhere
transpile :: Text -> ExceptT RenderError IO Text 
transpile md = do
  line   <- except $ first PErr $ runParser parseResume "" $ preprocess md
  group  <- except $ first GErr $ groupResume line
  prefix <- lift $ readFile prefixPath
  let tex = (<>) prefix $ show $ generateResume group
  lift $ writeFile texPath tex
  return $ T.pack tex

renderFile :: Maybe FilePath -> ExceptT RenderError IO ()
renderFile mdPath = do
  md <- lift $ TIO.readFile $ fromMaybe defaultMdPath mdPath
  render md

render :: Text -> ExceptT RenderError IO ()
render md = do
  _  <- transpile md 

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
executeRender mdPath = do
  result <- runExceptT $ renderFile mdPath
  case result of
    Left err -> print err
    Right _  -> return ()

executeTranspile :: Maybe FilePath -> IO ()
executeTranspile mdPath = do
  md  <- TIO.readFile $ fromMaybe defaultMdPath mdPath
  res <- runExceptT (transpile md)
  case res of
    Left err  -> print err
    Right tex -> TIO.putStrLn tex

