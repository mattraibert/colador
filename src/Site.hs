{-# Language OverloadedStrings, GADTs, TemplateHaskell, QuasiQuotes, FlexibleInstances, TypeFamilies, NoMonomorphismRestriction, ScopedTypeVariables, FlexibleContexts #-}

module Site where

import Data.ByteString (ByteString)
import Snap.Snaplet
import Snap.Snaplet.Heist
import Snap.Util.FileServe
import Snap.Snaplet.Groundhog.Postgresql
import Event.Handler

import Application

routes :: [(ByteString, Handler App App ())]
routes = [("/events", eventRoutes),
          ("/static", serveDirectory "static")]

app :: SnapletInit App App
app = makeSnaplet "colador" "An event mapping application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    g <- nestSnaplet "groundhog" groundhog initGroundhogPostgres
    addRoutes routes
    return $ App h g
