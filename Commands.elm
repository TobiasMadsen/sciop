module Commands exposing (fetchFarmListCmd, fetchEntityListCmd)

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
    Http.getString (api ++ "/entities/farms/" ++ farmId ++ "/entities/entities.json")

fetchEntityListCmd : String -> Cmd Msg
fetchEntityListCmd farmId =
    Http.send FetchEntityListCompleted (fetchEntityList farmId)
