module View exposing (..)

import Models exposing (..)
import Msgs exposing (..)
import Table exposing (defaultCustomizations)
import Html exposing (Html, Attribute, button, div, text, program, a, table, h2)
import Html.Events exposing (onClick)

-- VIEW FARMLIST

configFarmTable : Table.Config Farm Msg
configFarmTable =
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
                , div [] [ Table.view configFarmTable model.farmlistTableState model.farmList ]
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
