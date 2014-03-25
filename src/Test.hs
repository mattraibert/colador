{-# LANGUAGE OverloadedStrings, NoMonomorphismRestriction #-}

module Test where

import qualified Data.Map as M
import Control.Monad (void)
import Snap.Snaplet.Groundhog.Postgresql hiding (get)
import Snap.Core
import Snap.Test.BDD

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
       eval $ gh $ insert_ (Event "Alabaster" "Baltimore" "Crenshaw")
       contains (get "/events") "<table"
       contains (get "/events") "<td"
       contains (get "/events") "Alabaster"
       contains (get "/events") "Crenshaw"
       notcontains (get "/events") "Baltimore"
     it "provides a form to enter an Event" $ do 
       contains (get "/events/new") "<form"
       contains (get "/events/new") "title"
       contains (get "/events/new") "content"
     it "creates an Event in the database" $ do
       changes (+1)
         (gh $ countAll (undefined :: Event))
         (post "/events/new" $ params [("new-event.title", "Best Event"),
                                       ("new-event.content", "Great things happened!"),
                                       ("new-event.citation", "ibid.")])
     it "validates presence of title, content and citation" $ do
       form (Value $ Event "a" "b" "c") eventForm $
         M.fromList [("title", "a"), ("content", "b"), ("citation", "c")]
       form (ErrorPaths ["title", "content", "citation"]) eventForm $ M.fromList []
