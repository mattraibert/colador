{-# Language OverloadedStrings, GADTs, TemplateHaskell, QuasiQuotes, FlexibleInstances, TypeFamilies, NoMonomorphismRestriction, ScopedTypeVariables, FlexibleContexts #-}

module Event.Handler where

import Prelude hiding ((++))
import Control.Applicative
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as B8
import qualified Data.Text as T
import Data.Text (Text)
import Snap.Snaplet.PostgresqlSimple
import Snap.Core
import Snap.Snaplet
import Snap.Snaplet.Heist
import Heist
import Heist.Interpreted
import Snap.Util.FileServe
import Snap.Snaplet.Groundhog.Postgresql
import qualified Database.Groundhog.TH as TH
import Database.Groundhog.Core as GC
import Database.Groundhog.Utils
import Database.Groundhog.Utils.Postgresql as GUP
import Text.Digestive
import Text.Digestive.Snap (runForm)
import Text.Digestive.Heist

import Event.State
import Event.Handler.Helpers
import Helpers

import Application

eventRoutes :: AppHandler ()
eventRoutes = route [("", ifTop $ eventIndexHandler)
                    ,(":id", restfulEventHandler (\_method -> case _method of
                                                     DELETE -> deleteEventHandler
                                                     GET -> showEventHandler
                                                     _ -> pass))
                    ,("new", newEventHandler)
                    ,(":id/edit", editEventHandler)
                    ,("map", mapHandler)]

eventsHandler :: ByteString -> AppHandler ()
eventsHandler template =  do
  events <- gh GC.selectAll
  let eventEntities = map (uncurry Entity) events
  renderWithSplices template (eventsSplice eventEntities)

eventIndexHandler :: AppHandler ()
eventIndexHandler = eventsHandler "events/index"

mapHandler :: AppHandler ()
mapHandler = eventsHandler "events/map"

showEventHandler :: AppHandler ()
showEventHandler = do
  maybeEventKey <- eventKeyParam "id"
  case maybeEventKey of
    Nothing -> redirect "/events"
    Just eventKey -> do
      maybeEvent <- gh $ GC.get eventKey
      case maybeEvent of
        Nothing -> redirect "/events"
        Just event -> renderWithSplices "/events/show" $ eventSplice event

newEventHandler :: AppHandler ()
newEventHandler = do
  response <- runForm "new-event" (eventForm Nothing)
  case response of
    (v, Nothing) -> renderWithSplices "events/form" (digestiveSplices v)
    (_, Just e) -> do
      gh $ insert e
      redirect "/events"

editEventHandler :: AppHandler ()
editEventHandler = do
  maybeEventKey <- eventKeyParam "id"
  case maybeEventKey of
    Nothing -> pass
    Just eventKey -> do
      maybeEvent <- gh $ GC.get eventKey
      response <- runForm "edit-event" (eventForm $ maybeEvent)
      case response of
        (v, Nothing) -> renderWithSplices "events/form" (digestiveSplices v)
        (_, Just e) -> do
          gh $ replace eventKey e
          redirect "/events"

deleteEventHandler :: AppHandler ()
deleteEventHandler = do
  maybeEventKey <- eventKeyParam "id"
  case maybeEventKey of
    Nothing -> redirect "/events"
    Just eventKey -> do
      gh $ deleteBy eventKey
      redirect "/events"

eventsSplice :: [EventEntity] -> Splices (Splice AppHandler)
eventsSplice events = "events" ## mapSplices (runChildrenWith . eventEntitySplice) events

eventSplice :: Event -> Splices (Splice AppHandler)
eventSplice (Event _title _content _citation) = do
  "eventTitle" ## textSplice _title
  "eventContent" ## textSplice _content
  "eventCitation" ## textSplice _citation

eventEditPath :: AutoKey Event -> Text
eventEditPath eventId = (eventPath eventId) ++ "/edit"

eventPath :: AutoKey Event -> Text
eventPath eventId = "/events/" ++ (showText $ getId eventId)

eventEntitySplice :: EventEntity -> Splices (Splice AppHandler)
eventEntitySplice (Entity _id _event) = do
  "editLink" ## textSplice $ eventEditPath _id
  "eventLink" ## textSplice $ eventPath _id
  "eventX" ## textSplice $ showText $ (getId _id) * 25
  "eventY" ## textSplice $ showText $ (getId _id) * 25
  eventSplice _event

requiredTextField :: Text -> Text -> Form Text AppHandler Text
requiredTextField name defaultValue = name .: check "must not be blank" (not . T.null) (text $ Just defaultValue)

eventForm :: Maybe Event -> Form Text AppHandler Event
eventForm maybeEvent = case maybeEvent of
  Nothing -> form (Event "" "" "")
  (Just event) -> form event
  where
    form (Event _title _content _citation) =
      Event <$> requiredTextField "title" _title
      <*> requiredTextField "content" _content
      <*> requiredTextField "citation" _citation

readKey :: ByteString -> AutoKey Event
readKey = GUP.intToKey . read . B8.unpack

eventKeyParam :: MonadSnap m => ByteString -> m (Maybe (AutoKey Event))
eventKeyParam name = fmap (fmap readKey) (getParam name)


