module Remote.Types where

import Prelude
import Remote.Config

import Axios (class Axios, Method(..), defaultAxios)
import Data.Generic.Rep (class Generic)
import Data.Newtype (class Newtype)
import Foreign.Generic (class Decode, class Encode, defaultOptions, genericDecode, genericEncode)

newtype GetPriceForCryptosReq = GetPriceForCryptosReq
  { cryptoNames :: Array String
  , currencies :: Array String
  }
derive instance newtypeGetPriceForCryptosReq :: Newtype GetPriceForCryptosReq _
derive instance genericGetPriceForCryptosReq :: Generic GetPriceForCryptosReq _
instance encodeGetPriceForCryptosReq :: Encode GetPriceForCryptosReq where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })
instance decodeGetPriceForCryptosReq :: Decode GetPriceForCryptosReq where 
  decode = genericDecode(defaultOptions { unwrapSingleConstructors = true })

newtype Currency = Currency
  { name :: String
  , value :: Number
  }
derive instance newtypeCurrency :: Newtype Currency _
derive instance genericCurrency :: Generic Currency _
instance encodeCurrency :: Encode Currency where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })
instance decodeCurrency :: Decode Currency where 
  decode = genericDecode(defaultOptions { unwrapSingleConstructors = true })

newtype ResCoin = ResCoin
  { name :: String
  , prices :: Array Currency
  }
derive instance newtypeResCoin :: Newtype ResCoin _
derive instance genericResCoin :: Generic ResCoin _
instance encodeResCoin :: Encode ResCoin where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })
instance decodeResCoin :: Decode ResCoin where 
  decode = genericDecode(defaultOptions { unwrapSingleConstructors = true })

newtype GetPriceForCryptosRes = GetPriceForCryptosRes
  { results :: Array ResCoin
  }
derive instance newtypeGetPriceForCryptosRes :: Newtype GetPriceForCryptosRes _
derive instance genericGetPriceForCryptosRes :: Generic GetPriceForCryptosRes _
instance encodeGetPriceForCryptosRes :: Encode GetPriceForCryptosRes where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })
instance decodeGetPriceForCryptosRes :: Decode GetPriceForCryptosRes where 
  decode = genericDecode(defaultOptions { unwrapSingleConstructors = true })

instance axiosGetPriceForCryptos :: Axios GetPriceForCryptosReq GetPriceForCryptosRes where 
  axios = defaultAxios (baseUrl <> "/crypto_api/get_price_for_cryptos ") POST