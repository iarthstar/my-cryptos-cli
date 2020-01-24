module Remote.Config where

data Environment = PROD | STAGE | DEV | LOCAL

env :: Environment
env = PROD

baseUrl :: String
baseUrl = case env of
  PROD  -> "https://grandeur-backend.herokuapp.com"
  STAGE -> "https://grandeur-backend.herokuapp.com"
  DEV   -> "https://grandeur-backend.herokuapp.com"
  LOCAL -> "http://localhost:8080"