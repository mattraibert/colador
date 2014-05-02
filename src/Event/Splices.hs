{-# Language OverloadedStrings, GADTs, TemplateHaskell, QuasiQuotes, FlexibleInstances, TypeFamilies, NoMonomorphismRestriction, ScopedTypeVariables, FlexibleContexts #-}

module Event.Splices where

import Prelude hiding ((++))
import qualified Data.Text as T
import Data.Text (Text)
import Heist
import Heist.Interpreted
import Database.Groundhog.Core
import Database.Groundhog.Utils

import Event.Types
import Helpers
import Application

eventEditPath :: AutoKey Event -> Text
eventEditPath eventId = (eventPath eventId) ++ "/edit"

eventPath :: AutoKey Event -> Text
eventPath eventId = "/events/" ++ (showText $ getId eventId)

eventsSplice :: [EventEntity] -> Splices (Splice AppHandler)
eventsSplice events = "events" ## mapSplices (runChildrenWith . eventEntitySplice) events

eventSplice :: Event -> Splices (Splice AppHandler)
eventSplice (Event _title _content _citation (YearRange _startYear _endYear)) = do
  "eventTitle" ## textSplice _title
  "eventContent" ## textSplice _content
  "eventCitation" ## textSplice _citation
  "eventYears" ## textSplice $ T.pack $ unwords $ map show [_startYear.._endYear]
  "eventStart" ## textSplice $ showText _startYear
  "eventEnd" ## textSplice $ showText _endYear

eventEntitySplice :: EventEntity -> Splices (Splice AppHandler)
eventEntitySplice (Entity _id _event) = do
  "editLink" ## textSplice $ eventEditPath _id
  "eventLink" ## textSplice $ eventPath _id
  "eventX" ## textSplice $ showText $ (getId _id) * 25
  "eventY" ## textSplice $ showText $ (getId _id) * 25
  eventSplice _event
