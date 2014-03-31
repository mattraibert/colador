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
  citation :: Text
  } deriving (Show, Eq)

type EventEntity = Entity (AutoKey Event) Event

TH.mkPersist
  TH.defaultCodegenConfig { TH.namingStyle = TH.lowerCaseSuffixNamingStyle }
  [TH.groundhog| - entity: Event |]

getId :: AutoKey Event -> Int
getId (EventKey (PersistInt64 _id)) = fromIntegral _id :: Int
