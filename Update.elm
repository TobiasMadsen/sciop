module Update exposing (..)

import Models exposing (..)
import Msgs exposing (..)
import Commands exposing(..)

import Json.Decode exposing (map2, map3, field, int, string, decodeString, list)
import Http

-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotoFarmListView ->
            ( {model | viewState = FarmListView} , Cmd.none )
        GotoFarmView farmId ->
            ( {model | viewState = FarmView, farmId = farmId}, fetchEntityListCmd farmId )
        GotoEntityView entityId ->
            ( {model | viewState = EntityView, entityId = entityId}, fetchEntityCmd model.farmId entityId)
        FetchFarmListCompleted result ->
            fetchFarmListCompleted model result
        FetchEntityListCompleted result ->
            fetchEntityListCompleted model result
        FetchEntityCompleted result ->
            fetchEntityCompleted model result                
        SetFarmListTableState newState ->
            ( { model | farmListTableState = newState }, Cmd.none )
        SetEntityListTableState newState ->
            ( { model | entityListTableState = newState }, Cmd.none )

-- PARSE FARM LIST

fetchFarmListCompleted : Model -> Result Http.Error String -> ( Model, Cmd Msg )
fetchFarmListCompleted model result =
    let
        farm = map2 Farm (field "id" string) (field "name" string)
        farmListDecoder json =
            let
                farmListDecodeResult = (decodeString (list farm) json)
            in
                case farmListDecodeResult of
                    Ok farmList ->
                        farmList
                    Err _  ->
                        []
                    
    in
        case result of
            Ok json ->
                ( {model | farmList = farmListDecoder json}, Cmd.none )
                    
            Err _ ->
                ( model, Cmd.none )

-- PARSE ENTITY LIST
fetchEntityListCompleted : Model -> Result Http.Error String -> (Model, Cmd Msg)
fetchEntityListCompleted model result =
    let
        entityListElem = map3 EntityListElem (field "id" string) (field "startDate" string) (field "endDate" string)
        entityListDecoder json =
            let
                entityListDecodeResult = (decodeString (list entityListElem) json)
            in
                case entityListDecodeResult of
                    Ok entityList ->
                        entityList
                    Err _  ->
                        [{id = "Error 2", startDate = "hej", endDate = "du"}]
                    
    in
        case result of
            Ok json ->
                ( {model | entityList = entityListDecoder json}, Cmd.none )
                    
            Err errStr ->
                ( {model | entityList = [{id = (toString errStr), startDate = "hej", endDate = "du"}] }, Cmd.none )

-- PARSE ENTITY
fetchEntityCompleted : Model -> Result Http.Error String -> (Model, Cmd Msg)
fetchEntityCompleted model result =
    (model, Cmd.none)
