module Main where

import Prelude

import Axios (axios)
import Chalk as C
import Data.Array (drop, foldl, (!!))
import Data.Either (Either(..))
import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), split)
import Data.String.Utils (padEnd)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff as Aff
import Effect.Class (liftEffect)
import Effect.Console (logShow, log)
import Remote.Types (Currency(..), GetPriceForCryptosReq(..), GetPriceForCryptosRes(..), ResCoin(..))

foreign import argv :: Array String

args :: Array String
args = drop 2 argv

getValues :: String -> Tuple String String
getValues str = 
  let arr = split (Pattern "=") str
  in case (arr !! 0), (arr !! 1) of
    Just "--coins" , Just ""  -> Tuple "" ""
    Just "--coins" , Just a   -> Tuple "coins" a
    Just "--currs" , Just ""  -> Tuple "" ""
    Just "--currs" , Just a   -> Tuple "currs" a
    _                , _      -> Tuple "" ""

printCoin :: ResCoin -> Effect Unit
printCoin (ResCoin coin) = 
  let prices = foldl (\str (Currency c) -> (c.name) <> ": " <> (C.greenBright $ padEnd 12 $ show c.value) <> str) "" coin.prices
  in log $ (C.cyan $ padEnd 8 coin.name) <> prices

getPriceForCryptos :: String -> String -> Effect Unit
getPriceForCryptos coins currs = Aff.launchAff_ do
  let req = GetPriceForCryptosReq
        { cryptoNames: split (Pattern ",") coins
        , currencies: split (Pattern ",") currs
        }
  axios req >>= liftEffect <<< case _ of
    Left err                          -> logShow err
    Right (GetPriceForCryptosRes res) -> traverse_ printCoin res.results

main :: Effect Unit
main = do
  let values = case (getValues <$> args) !! 0, (getValues <$> args) !! 1 of
        Just (Tuple "coins" coins), Just (Tuple "currs" currs)  -> Tuple coins currs
        Just (Tuple "coins" coins), _                           -> Tuple coins "USD,INR"
        _                         , _                           -> Tuple "" ""
  case values of
    Tuple "" ""       -> log "No Coins Found"
    Tuple coins currs -> getPriceForCryptos coins currs

