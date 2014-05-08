{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

------------------------------------------------------------------------------
-- | This module defines our application's state type and an alias for its
-- handler monad.
module Application where

------------------------------------------------------------------------------
import Control.Lens
import Snap.Snaplet.Persistent
import Snap.Snaplet
import Snap.Snaplet.Heist
import Data.Monoid (Monoid, mappend)

------------------------------------------------------------------------------
data App = App
    { _heist :: Snaplet (Heist App)
    , _persistent :: Snaplet PersistState
    }

makeLenses ''App

instance HasHeist App where
    heistLens = subSnaplet heist


instance HasPersistPool (Handler b App) where
    getPersistPool = with persistent getPersistPool

------------------------------------------------------------------------------
type AppHandler = Handler App App

(++) :: Monoid d => d -> d -> d
(++) = mappend
