{-# Language OverloadedStrings, GADTs, TemplateHaskell, QuasiQuotes, FlexibleInstances, TypeFamilies, NoMonomorphismRestriction, ScopedTypeVariables, FlexibleContexts #-}

module Event.Handler.Helpers where

import Snap.Core
import qualified Data.ByteString.Char8 as B8
import Application

methodParam :: MonadSnap m => m Snap.Core.Method
methodParam = fmap parseMethod $ getParam "_method"
  where parseMethod param = case param of
          Nothing -> GET
          Just _method -> read $ B8.unpack _method

restfulEventHandler :: (Snap.Core.Method -> AppHandler ()) -> AppHandler ()
restfulEventHandler mapping = do
  _method <- methodParam
  mapping _method

