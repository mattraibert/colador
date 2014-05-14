{-# Language OverloadedStrings, GADTs, TemplateHaskell, QuasiQuotes, FlexibleInstances, TypeFamilies, NoMonomorphismRestriction, ScopedTypeVariables, FlexibleContexts #-}

module Event.Splices where

import Prelude hiding ((++))
import qualified Data.Text as T
import Data.Text (Text)
import Heist
import Heist.Interpreted

import Database.Persist.Types
import qualified Snap.Snaplet.Persistent as P

import Event.Types
import Helpers
import Application

eventEditPath :: Key Event -> Text
eventEditPath eventId = (eventPath eventId) ++ "/edit"

eventPath :: Key Event -> Text
eventPath eventId = "/events/" ++ (P.showKey eventId)

eventsSplice :: [EventEntity] -> Splices (Splice AppHandler)
eventsSplice events = "events" ## mapSplices (runChildrenWith . eventEntitySplice) events

eventSplice :: Event -> Splices (Splice AppHandler)
eventSplice (Event _title _content _citation _startYear _endYear _) = do
  "eventTitle" ## textSplice _title
  "eventContent" ## textSplice _content
  "eventCitation" ## textSplice _citation
  "eventStart" ## textSplice $ showText _startYear
  "eventEnd" ## textSplice $ showText _endYear

eventEntitySplice :: EventEntity -> Splices (Splice AppHandler)
eventEntitySplice (Entity _id _event) = do
  "editLink" ## textSplice $ eventEditPath _id
  "eventLink" ## textSplice $ eventPath _id
  "eventX" ## textSplice $ P.showKey _id
  "eventY" ## textSplice $ P.showKey _id
  eventSplice _event
