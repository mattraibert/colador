module Delete where

import Data.ByteString (ByteString)
import qualified Snap.Test as Test
import Snap.Test.BDD

delete :: ByteString -> TestRequest
delete url = Test.delete url $ params []