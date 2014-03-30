{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

------------------------------------------------------------------------------
-- | This module defines our application's state type and an alias for its
-- handler monad.
module Application where

------------------------------------------------------------------------------
import Control.Lens
import Snap (get)
import Snap.Snaplet.Groundhog.Postgresql (HasGroundhogPostgres(..), GroundhogPostgres)
import Snap.Snaplet
import Snap.Snaplet.Heist
import Prelude hiding ((++))
import Data.Monoid (Monoid, mappend)

------------------------------------------------------------------------------
data App = App
    { _heist :: Snaplet (Heist App)
    , _groundhog :: Snaplet GroundhogPostgres
    }

makeLenses ''App

instance HasHeist App where
    heistLens = subSnaplet heist

instance HasGroundhogPostgres (Handler b App) where
  getGroundhogPostgresState = with groundhog get

------------------------------------------------------------------------------
type AppHandler = Handler App App

(++) :: Monoid d => d -> d -> d
(++) = mappend
