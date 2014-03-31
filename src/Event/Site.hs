{-# Language OverloadedStrings, GADTs, TemplateHaskell, QuasiQuotes, FlexibleInstances, TypeFamilies, NoMonomorphismRestriction, ScopedTypeVariables, FlexibleContexts #-}

module Event.Site where

import Prelude hiding ((++))
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as B8
import Snap.Core
import Snap.Snaplet.Heist
import Snap.Snaplet.Groundhog.Postgresql
import Database.Groundhog.Core as GC
import Database.Groundhog.Utils
import Database.Groundhog.Utils.Postgresql as GUP
import Text.Digestive.Snap (runForm)
import Text.Digestive.Heist

import Event.Digestive
import Event
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
    Nothing -> home
    Just eventKey -> do
      maybeEvent <- gh $ GC.get eventKey
      case maybeEvent of
        Nothing -> home
        Just event -> renderWithSplices "/events/show" $ eventSplice event

newEventHandler :: AppHandler ()
newEventHandler = do
  response <- runForm "new-event" (eventForm Nothing)
  case response of
    (v, Nothing) -> renderWithSplices "events/form" (digestiveSplices v)
    (_, Just e) -> do
      gh $ insert e
      home

editEventHandler :: AppHandler ()
editEventHandler = do
  maybeEventKey <- eventKeyParam "id"
  case maybeEventKey of
    Nothing -> home
    Just eventKey -> do
      maybeEvent <- gh $ GC.get eventKey
      response <- runForm "edit-event" (eventForm $ maybeEvent)
      case response of
        (v, Nothing) -> renderWithSplices "events/form" (digestiveSplices v)
        (_, Just e) -> do
          gh $ replace eventKey e
          home

deleteEventHandler :: AppHandler ()
deleteEventHandler = do
  maybeEventKey <- eventKeyParam "id"
  case maybeEventKey of
    Nothing -> home
    Just eventKey -> do
      gh $ deleteBy eventKey
      home

readKey :: ByteString -> AutoKey Event
readKey = GUP.intToKey . read . B8.unpack

eventKeyParam :: MonadSnap m => ByteString -> m (Maybe (AutoKey Event))
eventKeyParam name = fmap (fmap readKey) (getParam name)


