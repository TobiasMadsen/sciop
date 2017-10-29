module App exposing (..)

import Html exposing (Html, Attribute, button, div, text, program, a, table, h2)
import Html.Events exposing (onClick)
import Http
import Debug
import Json.Decode exposing (map2, map3, field, int, string, decodeString, list)
import Table exposing (defaultCustomizations)

-- API
api : String
api =
    "http://localhost:8000/api/"

-- MODEL

type alias Farm = { id : String, name : String }
type alias Entity = { id : String, startDate : String, endDate : String}
    
type ViewState = FarmListView | FarmView | EntityView
type alias Model = { viewState : ViewState,
                     farmId : String,
                     entityId : Int,
                     farmList : List Farm ,
                     entityList : List Entity,
                     farmlistTableState : Table.State,
                     entitylistTableState : Table.State
                     }

init : ( Model, Cmd Msg )
init =
    ( { viewState = FarmListView,
        farmId = "",
        entityId = -1,
        farmList = [],
        entityList = [],
        farmlistTableState = Table.initialSort "id",
        entitylistTableState = Table.initialSort "id"
      }, fetchFarmListCmd )



-- MESSAGES

type Msg =
    GotoFarmListView |
    GotoFarmView String |
    GotoEntityView |
    FetchFarmListCompleted (Result Http.Error String) |
    FetchEntityListCompleted (Result Http.Error String) |
    SetTableState Table.State


-- FETCH FARM-LIST

fetchFarmList : Http.Request String
fetchFarmList =
    Http.getString (api ++ "farms.json")

fetchFarmListCmd : Cmd Msg
fetchFarmListCmd =
    Http.send FetchFarmListCompleted fetchFarmList

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

-- FETCH ENTITY-LIST

fetchEntityList : String -> Http.Request String
fetchEntityList farmId =
    Http.getString (api ++ "/entities/farms/" ++ farmId ++ "/entities/entities.json")
    -- Http.getString (api ++ "/entities/farms/" ++ farmId ++ "/entities/entities.json")

fetchEntityListCmd : String -> Cmd Msg
fetchEntityListCmd farmId =
    Http.send FetchEntityListCompleted (fetchEntityList farmId)

fetchEntityListCompleted : Model -> Result Http.Error String -> (Model, Cmd Msg)
fetchEntityListCompleted model result =
    let
        entity = map3 Entity (field "id" string) (field "startDate" string) (field "endDate" string)
        entityListDecoder json =
            let
                entityListDecodeResult = (decodeString (list entity) json)
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
                    
-- VIEW FARMLIST

config : Table.Config Farm Msg
config =
  Table.customConfig
    { toId = .id
    , toMsg = SetTableState
    , columns =
        [ Table.stringColumn "Id" .id
        , Table.stringColumn "Name" .name
        ]
    , customizations = { defaultCustomizations | rowAttrs = toRowAttrs }
    }

toRowAttrs : Farm -> List (Attribute Msg)
toRowAttrs farm =
  [ onClick (GotoFarmView farm.id)
  ]
                    
-- VIEW ENTITYLIST

configEntityTable : Table.Config Entity Msg
configEntityTable =
  Table.config
    { toId = .id
    , toMsg = SetTableState
    , columns =
        [ Table.stringColumn "Id" .id
        , Table.stringColumn "StartDate" .startDate
        , Table.stringColumn "EndDate" .endDate
        ]
    }

-- VIEW

view : Model -> Html Msg
view model =
    case model.viewState of
        FarmListView  ->
            div []
                [ a [ onClick GotoFarmListView ] [ text "Farms" ]
                , div [] [ Table.view config model.farmlistTableState model.farmList ]
                ]
        FarmView ->
            div []
                [ a [ onClick GotoFarmListView ] [ text "Farms>>" ]
                , a [ onClick (GotoFarmView model.farmId)] [ text ("FarmView " ++ model.farmId) ]
                , div [] [ Table.view configEntityTable model.entitylistTableState model.entityList]
                ]
        EntityView ->
            div []
                [ a [ onClick GotoFarmListView ] [ text "FarmListView>>" ]
                , a [ onClick (GotoFarmView model.farmId)] [ text ("FarmView " ++ model.farmId ++ ">>") ]                      
                , a [ onClick GotoEntityView ] [ text "EntityView" ]
                , div [] [text "EntityView"]
                ]


-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotoFarmListView ->
            ( {model | viewState = FarmListView} , Cmd.none )
        GotoFarmView farmId->
            ( {model | viewState = FarmView, farmId = farmId}, fetchEntityListCmd farmId )
        GotoEntityView ->
            ( {model | viewState = EntityView}, Cmd.none)
        FetchFarmListCompleted result ->
            fetchFarmListCompleted model result
        FetchEntityListCompleted result ->
            fetchEntityListCompleted model result
        SetTableState newState ->
            ( { model | farmlistTableState = newState }, Cmd.none )
            


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
