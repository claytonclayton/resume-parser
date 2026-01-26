{-# LANGUAGE OverloadedStrings #-}
module Resume.Server (server) where

import Web.Scotty
import Network.Wai.Middleware.Static
import Data.Text.Lazy (toStrict)
import Data.Text.Lazy.Encoding (decodeUtf8)
import Network.HTTP.Types (status500)
import qualified Data.Text.Lazy as TL
import Control.Monad.Trans.Class

import Resume.Render 
  ( runRender
  , serverConfig
  ) 

server :: IO ()
server = 
  scotty 3000 $ do

    middleware $ staticPolicy (addBase "static")

    get "/" $ do 
      lift $ putStrLn "front page accessed!"
      file "static/index.html"

    post "/render" $ do
      bodyText <- body

      let md = toStrict $ decodeUtf8 bodyText
      result <- lift $ runRender serverConfig md

      case result of
        Left err -> do
          status status500
          text $ TL.pack $ show err
          lift $ putStrLn $ "error: " <> show err
        
        Right _ -> do
          lift $ putStrLn "md successfully rendered!"
          file "me/pipeline/pdf/resume.pdf"
