{-# LANGUAGE OverloadedStrings #-}

module Test where

import Control.Lens (use)
import qualified Data.Map as M
import Data.Maybe (isJust, fromJust)
import Data.Text (Text)
import Control.Applicative
import Control.Monad (void)
import Control.Monad.Trans (liftIO)
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as B8
import Data.ByteString (ByteString)
import Data.Time.Calendar
import Data.Time.Clock
import Data.Time.Format
import System.Locale (defaultTimeLocale)
import System.Random (randomIO)

import Snap.Core
import Snap.Snaplet
import Snap.Test.BDD

import Application
import Site

main :: IO ()
main = do
  runSnapTests [consoleReport]
               (route routes) app $ do
    eventTests
  putStrLn ""


eventTests :: SnapTesting App ()
eventTests =
  do name "events shows you a blank page" $ succeeds (get "/events")
     name "there's a form that I can enter events into" $ do 
       contains (get "/events/new") "<form"
       contains (get "/events/new") "title"
       contains (get "/events/new") "content"
