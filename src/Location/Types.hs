{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, TemplateHaskell,
             OverloadedStrings, GADTs, FlexibleContexts, EmptyDataDecls #-}

module Location.Types where

import Database.Persist.TH
import Database.Persist.Types
import Data.Text (Text)

import Application ()

share [mkPersist sqlSettings] [persistLowerCase|
Location
    location Text
    x Int
    y Int
    deriving Show
    deriving Eq
|]

type LocationEntity = Entity Location