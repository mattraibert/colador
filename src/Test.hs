{-# LANGUAGE OverloadedStrings, NoMonomorphismRestriction, GADTs #-}

module Test where

import qualified Data.Map as M
import Control.Monad (void)
import Snap.Snaplet.Groundhog.Postgresql hiding (get)
import Snap.Core
import Snap.Test.BDD
import qualified Data.Text as T
import Data.Text.Encoding

import Application
import Site

it = name

main :: IO ()
main = do
  runSnapTests defaultConfig (route routes) app $ do
    eventTests
  putStrLn ""

eventTests :: SnapTesting App ()
eventTests = cleanup (void $ gh $ deleteAll (undefined :: Event)) $
  do
     it "shows a table filled with events" $ do
       eventId <- eval $ gh $ insert (Event "Alabaster" "Baltimore" "Crenshaw")
       contains (get "/events") "<table"
       contains (get "/events") "<td"
       contains (get "/events") "Alabaster"
       contains (get "/events") "Crenshaw"
       notcontains (get "/events") "Baltimore"
       contains (get "/events") $ eventEditPath eventId
     it "provides a form to enter an Event" $ do
       contains (get "/events/new") "<form"
       contains (get "/events/new") "title"
       contains (get "/events/new") "content"
     it "provides a form to enter an Event" $ do
       eventId <- eval $ gh $ insert (Event "Alabaster" "Baltimore" "Crenshaw")
       let editPath = encodeUtf8 $ eventEditPath eventId
       contains (get editPath) "<form"
       contains (get editPath) "Alabaster"
       contains (get editPath) "Baltimore"
       contains (get editPath) "Crenshaw"
       it "replaces the Event in the database on update" $ do
         changes (+0)
           (gh $ countAll (undefined :: Event))
           (post editPath $ params [("new-event.title", "a"),
                                    ("new-event.content", "b"),
                                    ("new-event.citation", "c")])
     it "creates a new Event in the database on create" $ do
       changes (+1)
         (gh $ countAll (undefined :: Event))
         (post "/events/new" $ params [("new-event.title", "a"),
                                       ("new-event.content", "b"),
                                       ("new-event.citation", "c")])
     it "validates presence of title, content and citation" $ do
       form (Value $ Event "a" "b" "c") (eventForm Nothing) $
         M.fromList [("title", "a"), ("content", "b"), ("citation", "c")]
       form (ErrorPaths ["title", "content", "citation"]) (eventForm Nothing) $ M.fromList []
