{-# LANGUAGE OverloadedStrings, MultiParamTypeClasses, TypeSynonymInstances,
             FlexibleInstances, NoMonomorphismRestriction, TypeFamilies,
            FlexibleContexts, UndecidableInstances, FunctionalDependencies #-}

module GroundhogWrapping where

import Snap.Snaplet.Groundhog.Postgresql
import Database.Groundhog.Core as G
import Snap.Test.BDD
import Snap.Snaplet

class Insert app entity key monad | monad -> app where
  insert :: entity -> monad key
  countAll :: entity -> monad Int
  deleteAll :: entity -> monad ()

instance (PersistEntity entity, key ~ AutoKey entity, HasGroundhogPostgres (Handler app app))
         => Insert app entity key (SnapTesting app) where
  insert    = eval . runGH . G.insert
  countAll  = eval . runGH . G.countAll
  deleteAll = eval . runGH . G.deleteAll

instance (PersistEntity entity, key ~ AutoKey entity, HasGroundhogPostgres (Handler app app))
         => Insert app entity key (Handler app app) where
  insert    = runGH . G.insert
  countAll  = runGH . G.countAll
  deleteAll = runGH . G.deleteAll
