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
import qualified Database.Groundhog.TH as TH
import           Snap.Snaplet.Groundhog.Postgresql
import           Text.Digestive
import           Text.Digestive.Snap
import           Text.Digestive.Heist

------------------------------------------------------------------------------
import           Application

eventForm :: Form Text AppHandler (Text, Text)
eventForm = (,) <$> "title" .: text Nothing
                <*>  "content" .: text Nothing

newEventHandler :: AppHandler ()
newEventHandler = do r <- runForm "new-event" eventForm
                     case r of
                       (v, Nothing) -> renderWithSplices "events/new" (digestiveSplices v)
                       (_, Just (title,content)) -> void (gh $ countAll (undefined :: Event))

data Event = Event {
  title :: Text,
  content :: Text
  } deriving Show

TH.mkPersist TH.defaultCodegenConfig { TH.namingStyle = TH.lowerCaseSuffixNamingStyle } [TH.groundhog|
                                                                                         - entity: Event
|]

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
    p <- nestSnaplet "pg" postgres pgsInit
    g <- nestSnaplet "groundhog" groundhog initGroundhogPostgres
    addRoutes routes
    return $ App h p g

