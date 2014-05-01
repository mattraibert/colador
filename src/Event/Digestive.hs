{-# Language OverloadedStrings, GADTs, TemplateHaskell, QuasiQuotes, FlexibleInstances, TypeFamilies, NoMonomorphismRestriction, ScopedTypeVariables, FlexibleContexts #-}

module Event.Digestive where

import Prelude hiding ((++))
import Control.Applicative
import qualified Data.Text as T
import Data.Text (Text)
import Heist
import Heist.Interpreted
import Database.Groundhog.Core
import Database.Groundhog.Utils
import Text.Digestive

import Event.Types
import Helpers
import Application

requiredTextField :: Text -> Text -> Form Text AppHandler Text
requiredTextField name defaultValue = name .: check "must not be blank" (not . T.null) (text $ Just defaultValue)

eventForm :: Maybe Event -> Form Text AppHandler Event
eventForm maybeEvent = case maybeEvent of
  Nothing -> form (Event "" "" "" (YearRange 0 0))
  (Just event) -> form event
  where
    form (Event _title _content _citation (YearRange _startYear _endYear)) =
      Event <$> requiredTextField "title" _title
      <*> requiredTextField "content" _content
      <*> requiredTextField "citation" _citation
      <*> (YearRange <$> "startYear" .: stringRead "must be a number" (Just _startYear)
           <*> "endYear" .: stringRead "must be a number" (Just _endYear))

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
