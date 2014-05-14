{-# LANGUAGE OverloadedStrings #-}
module Test.Event.Json where

import Data.Aeson
import Snap.Test.BDD
import Test.Common
import Control.Applicative
import Database.Persist.Types
import Snap.Snaplet.Persistent as P
import Application
import Event.Types
import Event.Json

eventJsonTests :: SnapTesting App ()
eventJsonTests = do
  it "produces JSON" $ do
    let mapEvent' = mapEvent (Entity (P.mkKey 1) (Event "Alabaster" "Baltimore" "Crenshaw" 1492 1494 $ P.mkKey 0))
        jsonObject = object ["startYear" .= (1492 :: Int),
                             "y".= (0 :: Int),
                             "x".= (0 :: Int),
                             "title".= ("Alabaster" :: String),
                             "id".= (1 :: Int),
                             "img".= ("/static/nature2.gif" :: String),
                             "endYear".= (1494 :: Int)]
    should $ equal <$> val (toJSON mapEvent') <*> val jsonObject
