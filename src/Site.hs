{-# LANGUAGE OverloadedStrings, GADTs, TemplateHaskell, QuasiQuotes, FlexibleInstances, TypeFamilies #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site where

------------------------------------------------------------------------------
import           Control.Applicative
import           Control.Monad
import           Data.ByteString (ByteString)
import qualified Data.Text as T
import           Data.Text (Text)
import           Snap.Snaplet.PostgresqlSimple
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Snap.Util.FileServe
import           Heist
import qualified Heist.Interpreted as I
import           Snap.Snaplet.Groundhog.Postgresql
import qualified Database.Groundhog.TH as TH
import           Text.Digestive
import           Text.Digestive.Snap
import           Text.Digestive.Heist

------------------------------------------------------------------------------
import           Application

data Event = Event {
  title :: Text,
  content :: Text,
  citation :: Text
  } deriving (Show, Eq)

TH.mkPersist
  TH.defaultCodegenConfig { TH.namingStyle = TH.lowerCaseSuffixNamingStyle }
  [TH.groundhog| - entity: Event |]

requiredTextField :: Text -> Form Text AppHandler Text
requiredTextField nm = nm .: check "must not be blank" (not . T.null) (text Nothing)

eventForm :: Form Text AppHandler Event
eventForm = Event <$> requiredTextField "title"
                  <*> requiredTextField "content"
                  <*> requiredTextField "citation"

newEventHandler :: AppHandler ()
newEventHandler = do
  response <- runForm "new-event" eventForm
  case response of
    (v, Nothing) -> renderWithSplices "events/new" (digestiveSplices v)
    (_, Just e) -> void $ gh $ insert e

eventIndexHandler :: AppHandler ()
eventIndexHandler = render "events/index"

eventRoutes :: (ByteString, Handler App App ())
eventRoutes = ("/events", route [("", ifTop $ eventIndexHandler)
                                ,("new", newEventHandler)])


------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = [eventRoutes, ("", serveDirectory "static")]

------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    p <- nestSnaplet "pg" postgres pgsInit
    g <- nestSnaplet "groundhog" groundhog initGroundhogPostgres
    addRoutes routes
    return $ App h p g
