{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, TemplateHaskell,
             OverloadedStrings, GADTs, FlexibleContexts, EmptyDataDecls #-}

module Event.Types where

import Data.Text (Text)
import Database.Persist.Types
import Database.Persist.TH
import Location.Types

import Application ()

share [mkPersist sqlSettings] [persistLowerCase|
Event
    title Text
    content Text
    citation Text
    startYear Int
    endYear Int
    locationId LocationId
    deriving Show
    deriving Eq
|]

type EventEntity = Entity Event
