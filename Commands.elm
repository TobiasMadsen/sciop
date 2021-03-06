module Commands exposing (fetchFarmListCmd, fetchEntityListCmd, fetchEntityCmd)

import Msgs exposing (..)
import Config exposing (api)

import Http

-- FETCH FARM-LIST COMMAND

fetchFarmList : Http.Request String
fetchFarmList =
    Http.getString (api ++ "farms.json")

fetchFarmListCmd : Cmd Msg
fetchFarmListCmd =
    Http.send FetchFarmListCompleted fetchFarmList

-- FETCH ENTITY-LIST COMMAND

fetchEntityList : String -> Http.Request String
fetchEntityList farmId =
    Http.request { method = "GET"
                 , headers = [(Http.header "accept" "application/json")]
                 , url = (api ++ "entities/farms/" ++ farmId ++ "/entities/entities.json")
                 , body = Http.emptyBody
                 , expect = Http.expectString
                 , timeout = Nothing
                 , withCredentials = False
                 }

fetchEntityListCmd : String -> Cmd Msg
fetchEntityListCmd farmId =
    Http.send FetchEntityListCompleted (fetchEntityList farmId)

-- FETCH ENTITY COMMAND

fetchEntity : String -> String -> Http.Request String
fetchEntity farmId entityId =
    Http.request { method = "GET"
                 , headers = [(Http.header "accept" "application/json")]
                 , url = (api ++ "entities/farms/" ++ farmId ++ "/entities/" ++ entityId ++ ".json")
                 , body = Http.emptyBody
                 , expect = Http.expectString
                 , timeout = Nothing
                 , withCredentials = False
                 }
        
fetchEntityCmd : String -> String -> Cmd Msg
fetchEntityCmd farmId entityId =
    Http.send FetchEntityCompleted (fetchEntity farmId entityId)
                                             
        

        
