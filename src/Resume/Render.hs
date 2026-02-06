
module Resume.Render 
  ( render
  , runRender
  , executeRender
  , executeRenderFile
  , executeTranspile
  , serverConfig
  , cliConfig
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
import Control.Monad.Reader

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

data Config = Config
  { quietRender :: Bool
  } 

serverConfig :: Config
serverConfig = Config 
  { quietRender = True
  }

cliConfig :: Config
cliConfig = Config
  { quietRender = False
  }

type RenderM a = ReaderT Config (ExceptT RenderError IO) a 

-- maybe convert to simply Either and move effects elsewhere
transpile :: Text -> ExceptT RenderError IO Text 
transpile md = do
  line   <- except $ first PErr $ runParser parseResume "" $ preprocess md
  group  <- except $ first GErr $ groupResume line
  prefix <- lift $ readFile prefixPath
  let tex = (<>) prefix $ show $ generateResume group
  lift $ writeFile texPath tex
  return $ T.pack tex

render :: Text -> RenderM ()
render md = do
  _       <- lift $ transpile md 
  isQuiet <- asks quietRender

  let 
    baseArg =
      [ "-pdf"
      , "-auxdir=" ++ auxPath
      , "-outdir=" ++ outPath
      , texPath
      ]
    quietArg = 
      if isQuiet
      then ("-quiet" :)
      else id
    args = quietArg baseArg

  (_, _, _, ph) <- liftIO $ createProcess (proc "latexmk" args)
  exitCode      <- liftIO $ waitForProcess ph

  case exitCode of
    ExitSuccess   -> return ()
    ExitFailure c -> lift $ throwE $ ExitCode c

executeRender :: Config -> Text -> IO ()
executeRender config md = do
  result <- runRender config md
  case result of
    Left err -> print err
    Right _  -> return ()

executeRenderFile :: Config -> Maybe FilePath -> IO ()
executeRenderFile config mdPath = do
  md <- TIO.readFile $ fromMaybe defaultMdPath mdPath
  executeRender config md

runRender :: Config -> Text -> IO (Either RenderError ())
runRender config md = runExceptT $ runReaderT (render md) config

executeTranspile :: Maybe FilePath -> IO ()
executeTranspile mdPath = do
  md  <- TIO.readFile $ fromMaybe defaultMdPath mdPath
  res <- runExceptT (transpile md)
  case res of
    Left err  -> print err
    Right tex -> TIO.putStrLn tex

