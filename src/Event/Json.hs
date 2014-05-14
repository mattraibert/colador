{-# LANGUAGE TemplateHaskell, OverloadedStrings #-}

module Event.Json where

import Data.Text (Text)
import Data.Aeson.TH
import Database.Persist.Types
import Snap.Snaplet.Persistent as P
import Event.Types

mapEvent :: EventEntity -> MapEvent
mapEvent (Entity key (Event title' _ _ startYear' endYear' _)) = MapEvent (P.mkInt key) title' "/static/nature2.gif" 0 0 startYear' endYear'

data MapEvent = MapEvent {
  id :: Int,
  title :: Text,
  img :: Text,
  x :: Double,
  y :: Double,
  startYear :: Int,
  endYear :: Int
  } deriving (Show)

$(deriveJSON defaultOptions ''MapEvent)
