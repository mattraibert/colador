{-# Language OverloadedStrings, GADTs, TemplateHaskell, QuasiQuotes, FlexibleInstances, TypeFamilies, NoMonomorphismRestriction, ScopedTypeVariables, FlexibleContexts #-}

module Event.Form where

import Prelude hiding ((++))
import Control.Applicative
import qualified Data.Text as T
import Data.Text (Text)
import Text.Digestive

import Event.Types
import Application

requiredTextField :: Text -> Text -> Form Text AppHandler Text
requiredTextField name defaultValue = name .: check "must not be blank" (not . T.null) (text $ Just defaultValue)

eventForm :: Maybe Event -> Form Text AppHandler Event
eventForm maybeEvent = case maybeEvent of
  Nothing -> form (Event "" "" "" 0 0)
  (Just event) -> form event
  where
    form (Event _title _content _citation _startYear _endYear) =
      Event <$> requiredTextField "title" _title
      <*> requiredTextField "content" _content
      <*> requiredTextField "citation" _citation
      <*> "startYear" .: stringRead "must be a number" (Just _startYear)
      <*> "endYear" .: stringRead "must be a number" (Just _endYear)
