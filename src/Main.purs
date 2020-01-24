module Main where

import Prelude

import Axios (axios)
import Chalk as Color
import Data.Array (drop, filter, foldl, (!!))
import Data.Either (Either(..))
import Data.FoldableWithIndex (traverseWithIndex_)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String (Pattern(..), split)
import Data.String.Utils (padEnd, padStart)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff as Aff
import Effect.Class (liftEffect)
import Effect.Console as Console
import Effect.Timer (setInterval)
import Remote.Types (Currency(..), GetPriceForCryptosReq(..), GetPriceForCryptosRes(..), ResCoin(..))
import Types (Args(..))

foreign import argv :: Array String
foreign import clear :: Effect Unit

args :: Array String
args = drop 2 argv

getValues :: String -> Tuple String String
getValues str = do
  let arr = split (Pattern "=") str
  case (arr !! 0), (arr !! 1) of
    Just "--coins" , Just ""  -> Tuple "" ""
    Just "--currs" , Just ""  -> Tuple "" ""
    Just "--coins" , Just a   -> Tuple "coins" a
    Just "--currs" , Just a   -> Tuple "currs" a
    Just "--watch" , _        -> Tuple "watch" "true"
    Just "-w"      , _        -> Tuple "watch" "true"
    _              , _        -> Tuple "" ""

printCoin :: Int -> ResCoin -> Effect Unit
printCoin index (ResCoin coin) = do
  let prices = foldl priceStr "" coin.prices
  Console.log $ (padStart 3 $ show $ index + 1) <> " " <> (Color.cyan $ padEnd 8 coin.name) <> prices
  where
    priceStr str (Currency c) = (c.name) <> ": " <> (Color.greenBright $ padEnd 12 $ show c.value) <> str

getPriceForCryptos :: String -> String -> Effect Unit
getPriceForCryptos coins currs = Aff.launchAff_ do
  let req = GetPriceForCryptosReq
        { cryptoNames: split (Pattern ",") coins
        , currencies: split (Pattern ",") currs
        }
  axios req >>= liftEffect <<< case _ of
    Left err                          -> Console.logShow err
    Right (GetPriceForCryptosRes res) -> do
                                          clear
                                          Console.log $ Color.magenta $ padEnd 4 "SNo" <> padEnd 8 "Name"
                                          traverseWithIndex_ printCoin res.results

findKey :: String -> Array (Tuple String String) -> Maybe String
findKey key arr = case filter (\(Tuple a b) -> a == key) arr !! 0 of
    Nothing           -> Nothing
    Just (Tuple _ b)  -> Just b

main :: Effect Unit
main = do
  let values = getValues <$> args
  let (Args parsed) = Args
        { coins: findKey "coins" values
        , currs: fromMaybe "USD,INR" $ findKey "currs" values
        , watch: "true" == (fromMaybe "" $ findKey "watch" values)
        }
  case parsed.coins, parsed.currs, parsed.watch of
    Just coins, currs, true -> do 
                                getPriceForCryptos coins currs
                                void $ setInterval 5000 $ getPriceForCryptos coins currs
    Just coins, currs, _    -> getPriceForCryptos coins currs
    _         , _    , _    -> Console.log "No coins found"
    
