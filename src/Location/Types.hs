{-# Language OverloadedStrings, GADTs, TemplateHaskell, QuasiQuotes, FlexibleInstances, TypeFamilies, NoMonomorphismRestriction, ScopedTypeVariables, FlexibleContexts #-}

module Location.Types where

import Data.Text (Text)
import qualified Database.Groundhog.TH as TH
import Database.Groundhog.Core as GC
import Database.Groundhog.Utils

import Application ()

data Location = Location {
  location :: Text,
  x :: Int,
  y :: Int
} deriving (Show, Eq)

type LocationEntity = Entity (AutoKey Location) Location

TH.mkPersist
  TH.defaultCodegenConfig { TH.namingStyle = TH.lowerCaseSuffixNamingStyle }
  [TH.groundhog|
   - entity: Location
               |]

getId :: AutoKey Location -> Int
getId (LocationKey (PersistInt64 _id)) = fromIntegral _id :: Int

makeId :: Int -> AutoKey Location
makeId _id = (LocationKey (PersistInt64 $ fromIntegral _id))
