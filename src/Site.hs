{-# LANGUAGE OverloadedStrings, GADTs, TemplateHaskell, QuasiQuotes, FlexibleInstances, TypeFamilies, NoMonomorphismRestriction, ScopedTypeVariables, FlexibleContexts #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site where

------------------------------------------------------------------------------
import           Prelude hiding ((++))
import           Control.Applicative
import           Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as B8
import qualified Data.Text as T
import           Data.Text (Text)
import           Snap.Snaplet.PostgresqlSimple
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Heist
import           Heist.Interpreted
import           Snap.Util.FileServe
import           Snap.Snaplet.Groundhog.Postgresql
import qualified Database.Groundhog.TH as TH
import           Database.Groundhog.Core as GC
import           Database.Groundhog.Utils 
import           Database.Groundhog.Utils.Postgresql as GUP
import           Text.Digestive
import           Text.Digestive.Snap
import           Text.Digestive.Heist

------------------------------------------------------------------------------
import           Application

type EventEntity = Entity (AutoKey Event) Event

data Event = Event {
  title :: Text,
  content :: Text,
  citation :: Text
  } deriving (Show, Eq)

showText :: Show a => a -> Text
showText = T.pack . show

TH.mkPersist
  TH.defaultCodegenConfig { TH.namingStyle = TH.lowerCaseSuffixNamingStyle }
  [TH.groundhog| - entity: Event |]


requiredTextField :: Text -> Text -> Form Text AppHandler Text
requiredTextField name defaultValue = name .: check "must not be blank" (not . T.null) (text $ Just defaultValue)

eventForm :: Maybe Event -> Form Text AppHandler Event
eventForm maybeEvent = case maybeEvent of
  Nothing -> form (Event "" "" "")
  (Just event) -> form event
  where
    form (Event _title _content _citation) = 
      Event <$> requiredTextField "title" _title
      <*> requiredTextField "content" _content
      <*> requiredTextField "citation" _citation

newEventHandler :: AppHandler ()
newEventHandler = do
  response <- runForm "new-event" (eventForm Nothing)
  case response of
    (v, Nothing) -> renderWithSplices "events/new" (digestiveSplices v)
    (_, Just e) -> do
      gh $ insert e
      redirect "/events"

getEvent :: (PersistBackend m) => Int -> m (Maybe Event)
getEvent eventId = GC.get (GUP.intToKey eventId)

intParam :: MonadSnap m => ByteString -> m (Maybe Int)
intParam name = fmap (fmap $ read . B8.unpack) (getParam name)

requestedEvent :: (MonadSnap m, HasGroundhogPostgres m) => m (Maybe Event)
requestedEvent = do
  maybeEventId <- intParam "id"
  case maybeEventId of
    Nothing -> pass
    Just eventId -> gh $ getEvent eventId

editEventHandler :: AppHandler ()
editEventHandler = do
  event <- requestedEvent
  response <- runForm "new-event" (eventForm $ event)
  case response of
    (v, Nothing) -> renderWithSplices "events/new" (digestiveSplices v)
    (_, Just e) -> do
      gh $ insert e
      redirect "/events"

getId :: Key Event u -> Int
getId (EventKey (PersistInt64 _id)) = fromIntegral _id :: Int

eventEditPath :: Key Event u -> Text
eventEditPath eventId = "/events/" ++ (showText $ (getId eventId)) ++ "/edit"

eventsSplice :: [EventEntity] -> Splices (Splice AppHandler)
eventsSplice events = "events" ## mapSplices (runChildrenWith . eventSplice) events

eventSplice :: (EventEntity) -> Splices (Splice AppHandler)
eventSplice (Entity _id (Event _title _content _citation)) = do
  "title" ## textSplice _title
  "eventcontent" ## textSplice _content
  "citation" ## textSplice _citation
  "editLink" ## textSplice $ eventEditPath _id


eventIndexHandler :: AppHandler ()
eventIndexHandler = do
  events <- gh GC.selectAll
  let eventEntities = map (uncurry Entity) events
  renderWithSplices "events/index" (eventsSplice eventEntities)

eventRoutes :: (ByteString, Handler App App ())
eventRoutes = ("/events", route [("", ifTop $ eventIndexHandler)
                                ,("new", newEventHandler)
                                ,(":id/edit", editEventHandler)
                                ])


------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = [eventRoutes, ("/static", serveDirectory "static")]

------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    p <- nestSnaplet "pg" postgres pgsInit
    g <- nestSnaplet "groundhog" groundhog initGroundhogPostgres
    addRoutes routes
    return $ App h p g
