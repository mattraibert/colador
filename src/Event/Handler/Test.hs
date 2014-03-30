{-# LANGUAGE OverloadedStrings, NoMonomorphismRestriction, GADTs #-}

module Event.Handler.Test where

import Prelude hiding ((++))
import qualified Data.Map as M
import Control.Monad (void)
import Snap.Snaplet.Groundhog.Postgresql hiding (get)
import Snap.Test.BDD
import Data.Text.Encoding

import Application
import Event.State
import Event.Handler.Digestive

it = name

insertEvent = eval $ gh $ insert (Event "Alabaster" "Baltimore" "Crenshaw")

eventTests :: SnapTesting App ()
eventTests = cleanup (void $ gh $ deleteAll (undefined :: Event)) $
  do
     it "#index" $ do
       eventKey <- insertEvent
       contains (get "/events") "<table"
       contains (get "/events") "<td"
       contains (get "/events") "Alabaster"
       contains (get "/events") "Crenshaw"
       notcontains (get "/events") "Baltimore"
       contains (get "/events") $ eventEditPath eventKey
     it "#map" $ do
       eventKey <- insertEvent
       contains (get "/events/map") "<svg"
       contains (get "/events/map") "<image xlink:href='/static/LAMap-grid.gif'"
       contains (get "/events/map") "<image xlink:href='/static/nature2.gif' title='Alabaster'"
       contains (get "/events/map") ("<a xlink:href='" ++ (eventPath eventKey))
     it "#show" $ do
       eventKey <- insertEvent
       let showPath = encodeUtf8 $ eventPath eventKey
       notcontains (get showPath) "<form"
       contains (get showPath) "Alabaster"
       contains (get showPath) "Baltimore"
       contains (get showPath) "Crenshaw"
     it "#new" $ do
       contains (get "/events/new") "<form"
       contains (get "/events/new") "title"
       contains (get "/events/new") "content"
     it "#edit" $ do
       eventKey <- insertEvent
       let editPath = encodeUtf8 $ eventEditPath eventKey
       contains (get editPath) "<form"
       contains (get editPath) "Alabaster"
       contains (get editPath) "Baltimore"
       contains (get editPath) "Crenshaw"
       it "#update" $ do
         changes (0 +)
           (gh $ countAll (undefined :: Event))
           (post editPath $ params [("new-event.title", "a"),
                                    ("new-event.content", "b"),
                                    ("new-event.citation", "c")])
     it "#create" $ do
       changes (1 +)
         (gh $ countAll (undefined :: Event))
         (post "/events/new" $ params [("new-event.title", "a"),
                                       ("new-event.content", "b"),
                                       ("new-event.citation", "c")])
     it "#deletes" $ do
       eventKey <- insertEvent
       changes (-1 +)
         (gh $ countAll (undefined :: Event))
         (post (encodeUtf8 $ eventPath eventKey) $ params [("_method", "DELETE")])
     it "validates presence of title, content and citation" $ do
       form (Value $ Event "a" "b" "c") (eventForm Nothing) $
         M.fromList [("title", "a"), ("content", "b"), ("citation", "c")]
       form (ErrorPaths ["title", "content", "citation"]) (eventForm Nothing) $ M.fromList []
