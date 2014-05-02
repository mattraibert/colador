{-# LANGUAGE OverloadedStrings #-}

module Test.Event.Handler where

import Prelude hiding ((++))
import qualified Data.Map as M
import Control.Monad (void)
import Snap.Snaplet.Groundhog.Postgresql hiding (get)
import Snap.Test.BDD
import Test.Common
import Control.Applicative

import Application
import Event.Types
import Event.Digestive

insertEvent = eval $ runGH $ insert (Event "Alabaster" "Baltimore" "Crenshaw" (YearRange 1492 1494))

eventTests :: SnapTesting App ()
eventTests = cleanup (void $ runGH $ deleteAll (undefined :: Event)) $
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
     it "#edit" $ do
       eventKey <- insertEvent
       let editPath = eventEditPath eventKey
       should $ haveText <$> (get editPath)  <*> val "<form"
       should $ haveText <$> (get editPath)  <*> val "Alabaster"
       should $ haveText <$> (get editPath)  <*> val "Baltimore"
       should $ haveText <$> (get editPath)  <*> val "Crenshaw"
       it "#update" $ do
         changes (0 +)
           (runGH $ countAll (undefined :: Event))
           (post editPath $ params [("new-event.title", "a"),
                                    ("new-event.content", "b"),
                                    ("new-event.citation", "c")])
     it "#create" $ do
       changes (1 +)
         (runGH $ countAll (undefined :: Event))
         (post "/events/new" $ params [("new-event.title", "a"),
                                       ("new-event.content", "b"),
                                       ("new-event.citation", "c")])
     it "#deletes" $ do
       eventKey <- insertEvent
       changes (-1 +)
         (runGH $ countAll (undefined :: Event))
         (post (eventPath eventKey) $ params [("_method", "DELETE")])
     it "validates presence of title, content and citation" $ do
       let expectedEvent = Event "a" "b" "c" (YearRange 1200 1300)
       form (Value expectedEvent) (eventForm Nothing) $
         M.fromList [("title", "a"), ("content", "b"), ("citation", "c"),
                     ("startYear", "1200"), ("endYear", "1300")]
       form (ErrorPaths ["title", "content", "citation"]) (eventForm Nothing) $ M.fromList []
