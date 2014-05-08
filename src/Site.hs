{-# Language OverloadedStrings, GADTs, FlexibleInstances, TypeFamilies, NoMonomorphismRestriction, ScopedTypeVariables, FlexibleContexts #-}

module Site where

import Data.ByteString (ByteString)
import Snap.Snaplet
import Snap.Core
import Snap.Snaplet.Heist
import Snap.Util.FileServe
import Snap.Snaplet.Persistent
import qualified Event.Handler

import Application

routes :: [(ByteString, Handler App App ())]
routes = [("/events", route Event.Handler.routes),
          ("/static", serveDirectory "static")]

app :: SnapletInit App App
app = makeSnaplet "colador" "An event mapping application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    p <- nestSnaplet "persistent" persistent $ initPersist (return ())
    addRoutes Site.routes
    return $ App h p
