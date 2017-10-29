module Update exposing (..)

import Models exposing (..)
import Msgs exposing (..)
import Commands exposing(..)

import Json.Decode exposing (map2, map3, map7, field, int, string, decodeString, list)
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
                        []
                    
    in
        case result of
            Ok json ->
                ( {model | entityList = entityListDecoder json}, Cmd.none )
                    
            Err errStr ->
                ( {model | entityList = [{id = toString errStr, startDate = "", endDate = ""}] }, Cmd.none )

-- PARSE ENTITY
temperatureDecoder = list (map2 TemperatureMeasurement (field "Time" string) (field "Measurement" int))
weightDecoder = list (map2 WeightMeasurement (field "Date" string) (field "Weightg" int))
entityDecoder = map7 Entity (field "Status" string) (field "StartDate" string) (field "EndDate" string) (field "Sex" string) (field "EntityAgeDays" int) (field "Temperatures" temperatureDecoder) (field "Weights" weightDecoder)
entityDecoderResult: String -> Entity                
entityDecoderResult json =
    let
        result = decodeString entityDecoder json
    in
        -- Handle errors in parsing Json
        case result of
            Ok entity ->
                entity
            Err errStr ->
                {defaultEntity | status = toString errStr}
    
fetchEntityCompleted : Model -> Result Http.Error String -> (Model, Cmd Msg)
fetchEntityCompleted model result =
    -- Handle errors in Http request
    case result of
        Ok json -> 
            ( {model | entity = (entityDecoderResult json)}, Cmd.none)
        Err errStr ->
            ( {model | entity = {defaultEntity | status = toString errStr}}, Cmd.none)
