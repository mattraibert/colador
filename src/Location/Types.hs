{-# Language OverloadedStrings, GADTs, TemplateHaskell, QuasiQuotes, FlexibleInstances, TypeFamilies, NoMonomorphismRestriction, ScopedTypeVariables, FlexibleContexts #-}

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