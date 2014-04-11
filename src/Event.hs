{-# Language OverloadedStrings, GADTs, TemplateHaskell, QuasiQuotes, FlexibleInstances, TypeFamilies, NoMonomorphismRestriction, ScopedTypeVariables, FlexibleContexts #-}

module Event where

import Data.Text (Text)
import qualified Database.Groundhog.TH as TH
import Database.Groundhog.Core as GC
import Database.Groundhog.Utils

import Application ()

data Event = Event {
  title :: Text,
  content :: Text,
  citation :: Text,
  years :: YearRange
  } deriving (Show, Eq)

data YearRange = YearRange {startYear :: Int, endYear :: Int} deriving (Show, Eq)

type EventEntity = Entity (AutoKey Event) Event

TH.mkPersist
  TH.defaultCodegenConfig { TH.namingStyle = TH.lowerCaseSuffixNamingStyle }
  [TH.groundhog|
   - entity: Event
   - embedded: YearRange
               |]

getId :: AutoKey Event -> Int
getId (EventKey (PersistInt64 _id)) = fromIntegral _id :: Int

makeId :: Int -> AutoKey Event 
makeId _id = (EventKey (PersistInt64 $ fromIntegral _id))
