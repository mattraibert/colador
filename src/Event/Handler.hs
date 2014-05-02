{-# Language OverloadedStrings, GADTs, TemplateHaskell, QuasiQuotes, FlexibleInstances, TypeFamilies, NoMonomorphismRestriction, ScopedTypeVariables, FlexibleContexts #-}

module Event.Handler where

import Prelude hiding ((++))
import Data.ByteString (ByteString)
import Data.Aeson
import qualified Data.ByteString.Char8 as B8
import Snap.Core
import Snap.Snaplet.Heist
import Snap.Snaplet.Groundhog.Postgresql
import Database.Groundhog.Core as GC
import Database.Groundhog.Utils
import Database.Groundhog.Utils.Postgresql as GUP
import Text.Digestive.Snap (runForm)
import Text.Digestive.Heist

import Event.Splices
import Event.Form
import Event.Types
import Event.Json
import Helpers

import Application

home :: AppHandler ()
home = redirect "/events"

routes :: [(ByteString, AppHandler ())]
routes = [("", ifTop $ eventIndexHandler)
                    ,(":id", restMethodDispatcher (\_method -> case _method of
                                                     DELETE -> deleteEventHandler
                                                     GET -> showEventHandler
                                                     _ -> home))
                    ,("new", newEventHandler)
                    ,(":id/edit", editEventHandler)
                    ,("map", mapHandler)
                    ,("index.json", eventsJsonHandler)]

eventsHandler :: ByteString -> AppHandler ()
eventsHandler template =  do
  events <- runGH GC.selectAll
  let eventEntities = map (uncurry Entity) events
  renderWithSplices template (eventsSplice eventEntities)

eventIndexHandler :: AppHandler ()
eventIndexHandler = eventsHandler "events/index"

mapHandler :: AppHandler ()
mapHandler = eventsHandler "events/map"

eventsJsonHandler :: AppHandler ()
eventsJsonHandler = do
  events <- runGH GC.selectAll
  let eventEntities = map (uncurry Entity) events
  modifyResponse $ setHeader "Content-Type" "application/json"
  writeLBS $ encode $ map mapEvent eventEntities

showEventHandler :: AppHandler ()
showEventHandler = do
  maybeEventKey <- eventKeyParam "id"
  case maybeEventKey of
    Nothing -> home
    Just eventKey -> do
      maybeEvent <- runGH $ GC.get eventKey
      case maybeEvent of
        Nothing -> home
        Just event -> renderWithSplices "/events/show" $ eventSplice event

newEventHandler :: AppHandler ()
newEventHandler = do
  response <- runForm "new-event" (eventForm Nothing)
  case response of
    (v, Nothing) -> renderWithSplices "events/form" (digestiveSplices v)
    (_, Just e) -> do
      runGH $ insert e
      home

editEventHandler :: AppHandler ()
editEventHandler = do
  maybeEventKey <- eventKeyParam "id"
  case maybeEventKey of
    Nothing -> home
    Just eventKey -> do
      maybeEvent <- runGH $ GC.get eventKey
      response <- runForm "edit-event" (eventForm $ maybeEvent)
      case response of
        (v, Nothing) -> renderWithSplices "events/form" (digestiveSplices v)
        (_, Just e) -> do
          runGH $ replace eventKey e
          home

deleteEventHandler :: AppHandler ()
deleteEventHandler = do
  maybeEventKey <- eventKeyParam "id"
  case maybeEventKey of
    Nothing -> home
    Just eventKey -> do
      runGH $ deleteBy eventKey
      home

readKey :: ByteString -> AutoKey Event
readKey = GUP.intToKey . read . B8.unpack

eventKeyParam :: MonadSnap m => ByteString -> m (Maybe (AutoKey Event))
eventKeyParam name = fmap (fmap readKey) (getParam name)


