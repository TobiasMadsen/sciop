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
    , toMsg = SetFarmListTableState
    , columns =
        [ Table.stringColumn "Id" .id
        , Table.stringColumn "Name" .name
        ]
    , customizations = { defaultCustomizations | rowAttrs = toRowAttrsFarmTable }
    }

toRowAttrsFarmTable : Farm -> List (Attribute Msg)
toRowAttrsFarmTable farm =
  [ onClick (GotoFarmView farm.id)
  ]

-- VIEW ENTITYLIST

configEntityTable : Table.Config Entity Msg
configEntityTable =
  Table.customConfig
    { toId = .id
    , toMsg = SetEntityListTableState
    , columns =
        [ Table.stringColumn "Id" .id
        , Table.stringColumn "StartDate" .startDate
        , Table.stringColumn "EndDate" .endDate
        ]
    , customizations = { defaultCustomizations | rowAttrs = toRowAttrsEntityTable}
    }
      
toRowAttrsEntityTable : Entity -> List (Attribute Msg)
toRowAttrsEntityTable entity =
  [ onClick (GotoEntityView entity.id)
  ]


-- VIEW

view : Model -> Html Msg
view model =
    case model.viewState of
        FarmListView  ->
            div []
                [ a [ onClick GotoFarmListView ] [ text "Farms" ]
                , div [] [ Table.view configFarmTable model.farmListTableState model.farmList ]
                ]
        FarmView ->
            div []
                [ a [ onClick GotoFarmListView ] [ text "Farms>>" ]
                , a [ onClick (GotoFarmView model.farmId)] [ text ("FarmView " ++ model.farmId) ]
                , div [] [ Table.view configEntityTable model.entityListTableState model.entityList]
                ]
        EntityView ->
            div []
                [ a [ onClick GotoFarmListView ] [ text "FarmListView>>" ]
                , a [ onClick (GotoFarmView model.farmId)] [ text ("FarmView " ++ model.farmId ++ ">>") ]                      
                , a [ onClick (GotoEntityView model.entityId) ] [ text "EntityView" ]
                , div [] [text "EntityView"]
                ]
