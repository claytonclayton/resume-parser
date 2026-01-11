{-# LANGUAGE OverloadedStrings #-}

module Resume.Server (server) where

import Web.Scotty

server :: IO ()
server = 
  scotty 3000 $
    get "/" $
      html "<h1>I am cat</h1>"    

