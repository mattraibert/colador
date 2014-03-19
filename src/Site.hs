{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site where

------------------------------------------------------------------------------
import           Control.Applicative
import           Data.ByteString (ByteString)
import qualified Data.Text as T
import           Snap.Snaplet.PostgresqlSimple
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Snap.Util.FileServe
import           Heist
import qualified Heist.Interpreted as I
import           Text.Digestive
import           Text.Digestive.Snap
import           Text.Digestive.Heist

------------------------------------------------------------------------------
import           Application

eventForm :: Form Text AppHandler Text
eventForm = "title" .: text Nothing

newEventHandler :: AppHandler ()
newEventHandler = do r <- runForm "new-event" eventForm
                     case r of
                       (Nothing, v) -> renderWithSplices (digestiveSplices v) "events/new"
                       (Just e, _) -> undefined

------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = [ ("/events", route [("", ifTop $ render "events/index")
                             ,("new", newEventHandler)])
         , ("", serveDirectory "static")
         ]

------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    p <- nestSnaplet "pg" pg pgsInit
    addRoutes routes
    return $ App h p

