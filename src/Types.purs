module Types where
  
import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)
import Foreign.Generic (class Decode, class Encode, defaultOptions, genericDecode, genericEncode)

newtype Args = Args
  { coins :: Maybe String
  , currs :: String
  , watch :: Boolean
  }
derive instance newtypeArgs :: Newtype Args _
derive instance genericArgs :: Generic Args _
instance encodeArgs :: Encode Args where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })
instance decodeArgs :: Decode Args where 
  decode = genericDecode(defaultOptions { unwrapSingleConstructors = true })
instance showArgs :: Show Args where
  show = genericShow