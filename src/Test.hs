{-# LANGUAGE OverloadedStrings, NoMonomorphismRestriction, GADTs #-}

module Test where

import Prelude hiding ((++))
import Snap.Core
import Snap.Test.BDD

import Site
import Event.Test

main :: IO ()
main = do
  runSnapTests defaultConfig (route routes) app $ do
    eventTests
  putStrLn ""
