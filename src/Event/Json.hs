{-# LANGUAGE TemplateHaskell, OverloadedStrings #-}

module Event.Json where

import Data.Text (Text)
import Data.Aeson.TH
import Database.Groundhog.Utils
import Event.Types

mapEvent :: EventEntity -> MapEvent
mapEvent (Entity key (Event title' _ _ (YearRange startYear' endYear'))) = MapEvent (getId key) title' "/static/nature2.gif" (fromIntegral $ getId key) (fromIntegral $ getId key) startYear' endYear'

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
