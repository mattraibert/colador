module Helpers where

import qualified Data.Text as T
import Data.Text (Text)

showText :: Show a => a -> Text
showText = T.pack . show
