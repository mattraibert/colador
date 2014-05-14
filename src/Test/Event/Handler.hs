{-# LANGUAGE OverloadedStrings #-}

module Test.Event.Handler where

import Prelude hiding ((++))
import qualified Data.Map as M
import Data.Maybe (fromJust)
import Control.Monad (void)
import Snap.Test.BDD
import Test.Common
import Control.Applicative
import Snap.Snaplet.Persistent
import Database.Persist (Filter)
import qualified Database.Persist as P

import Application
import Location.Types
import Event.Types
import Event.Form
import Event.Splices

insertLocation = eval $ runPersist $ P.insert (Location "Bostron" 45 44)
insertEvent = do locationId' <- insertLocation
                 eval $ runPersist $ P.insert (Event "Alabaster" "Baltimore" "Crenshaw" 1492 1494 locationId')

eventTests :: SnapTesting App ()
eventTests = cleanup (void deleteEvents) $
  do
     it "#index" $ do
       eventKey <- insertEvent
       should $ haveText <$> (get "/events") <*> val "<table"
       should $ haveText <$> (get "/events")  <*> val "<td"
       should $ haveText <$> (get "/events")  <*> val "Alabaster"
       should $ haveText <$> (get "/events")  <*> val "Crenshaw"
       should $ haveText <$> (get "/events")  <*> val "href='/events/new'"
       shouldNot $ haveText <$> (get "/events")  <*> val "Baltimore"
--       should $ haveText <$> (get "/events") <*> eventEditPath eventKey
     it "#map" $ do
       _eventKey <- insertEvent
       should $ haveText <$> (get "/events/map")  <*> val "<svg"
       should $ haveText <$> (get "/events/map")  <*> val "<image xlink:href='/static/LAMap-grid.gif'"
     it "#show" $ do
       eventKey <- insertEvent
       let showPath = eventPath eventKey
       shouldNot $ haveText <$> (get showPath)  <*> val "<form"
       should $ haveText <$> (get showPath)  <*> val "Alabaster"
       should $ haveText <$> (get showPath)  <*> val "Baltimore"
       should $ haveText <$> (get showPath)  <*> val "Crenshaw"
     it "#new" $ do
       should $ haveText <$> (get "/events/new")  <*> val "<form"
       should $ haveText <$> (get "/events/new")  <*> val "title"
       should $ haveText <$> (get "/events/new")  <*> val "content"
       should $ haveText <$> (get "/events/new")  <*> val "startYear"
       should $ haveText <$> (get "/events/new")  <*> val "endYear"
     locationKey <- insertLocation
     it "#edit" $ do
       eventKey <- insertEvent
       let editPath = eventEditPath eventKey
       should $ haveText <$> (get editPath)  <*> val "<form"
       should $ haveText <$> (get editPath)  <*> val "Alabaster"
       should $ haveText <$> (get editPath)  <*> val "Baltimore"
       should $ haveText <$> (get editPath)  <*> val "Crenshaw"
       it "#update" $ do
         changes (const ("New content", "a", "c"))
           (((\e -> (eventContent e, eventTitle e, eventCitation e)) . fromJust) <$> runPersist (P.get eventKey))
           (post editPath $ params [("edit-event.title", "a"),
                                    ("edit-event.content", "New content"),
                                    ("edit-event.citation", "c")])
     it "#create" $ do
       changes (1 +)
         (countEvents)
         (post "/events/new" $ params [("new-event.title", "a"),
                                       ("new-event.content", "b"),
                                       ("new-event.citation", "c"),
                                       ("new-event.location", showKeyBS locationKey)])
     it "#deletes" $ do
       eventKey <- insertEvent
       changes (-1 +)
         (countEvents)
         (post (eventPath eventKey) $ params [("_method", "DELETE")])
     it "validates presence of title, content and citation" $ do
       let expectedEvent = Event "a" "b" "c" 1200 1300 $ mkKey 0
       form (Value expectedEvent) (eventForm Nothing) $
         M.fromList [("title", "a"), ("content", "b"), ("citation", "c"),
                     ("startYear", "1200"), ("endYear", "1300")]
       form (ErrorPaths ["title", "content", "citation"]) (eventForm Nothing) $ M.fromList []


countEvents :: AppHandler Int
countEvents = runPersist $ P.count ([] :: [P.Filter Event])

deleteEvents :: AppHandler ()
deleteEvents = runPersist $ P.deleteWhere ([] :: [P.Filter Event])