{-# LANGUAGE OverloadedStrings #-}

module Test where

import Control.Lens (use)
import qualified Data.Map as M
import Data.Maybe (isJust, fromJust)
import Data.Text (Text)
import Control.Applicative
import Control.Monad (void)
import Control.Monad.Trans (liftIO)
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as B8
import Data.ByteString (ByteString)
import Data.Time.Calendar
import Data.Time.Clock
import Data.Time.Format
import System.Locale (defaultTimeLocale)
import System.Random (randomIO)
import Snap.Snaplet.Groundhog.Postgresql hiding (get)
import Snap.Core
import Snap.Snaplet
import Snap.Test.BDD

import Text.Digestive.Form.Encoding
import Text.Digestive.Form
import Text.Digestive.View
import Text.Digestive.Types
import Data.Map (Map)
import qualified Data.Map as M

import Application
import Site

main :: IO ()
main = do
  runSnapTests [consoleReport]
               (route routes) app $ do
    eventTests
  putStrLn ""

data FormExpectations a = Value a | ErrorPaths [Text] 

form :: (Eq a, Show a)
     => FormExpectations a
     -> Form Text AppHandler a
     -> (Map Text Text)
     -> SnapTesting App ()
form expected theForm theParams =
  do r <- eval $ postForm "form" theForm (const $ return lookupParam)
     case expected of
       Value a -> equals (snd r) (return $ Just a)
       ErrorPaths expectedPaths ->
         do let viewErrorPaths = map (fromPath . fst) $ viewErrors $ fst r
            equals (all (`elem` viewErrorPaths) expectedPaths) (return True)
  where lookupParam :: Path -> AppHandler [FormInput]
        lookupParam pth = case M.lookup (fromPath pth) fixedParams of
                            Nothing -> return []
                            Just v -> return [TextInput v]
        fixedParams = M.mapKeys (T.append "form.") theParams


eventTests :: SnapTesting App ()
eventTests = cleanup (void $ gh $ deleteAll (undefined :: Event)) $
  do name "events shows you a blank page" $ succeeds (get "/events")
     name "there's a form that I can enter events into" $ do 
       contains (get "/events/new") "<form"
       contains (get "/events/new") "title"
       contains (get "/events/new") "content"
     name "it gets into the database" $ do
       changes (+1)
         (gh $ countAll (undefined :: Event))
         (post "/events/new" $ params [("new-event.title", "Best Event"),
                                       ("new-event.content", "Great things happened!"),
                                       ("new-event.citation", "ibid.")])
       form (Value $ Event "a" "b" "c") eventForm $
         M.fromList [("title", "a"), ("content", "b"), ("citation", "c")]
       form (ErrorPaths ["title", "content", "citation"]) eventForm $ M.fromList []
