{-# LANGUAGE OverloadedStrings, NoMonomorphismRestriction, GADTs #-}

module Test.Main where

import Prelude hiding ((++))
import Snap.Core
import Snap.Test.BDD

import Site
import Test.Event.Handler
import Test.Event.Json

main :: IO ()
main = do
  runSnapTests defaultConfig { reportGenerators = [consoleReport, linuxDesktopReport] } (route routes) app $ do
    eventTests
    eventJsonTests
  putStrLn ""
