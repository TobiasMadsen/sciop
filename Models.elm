module Models exposing (..)

import Commands exposing (..)
import Msgs exposing (..)

import Table

-- MODEL

type alias Farm = { id : String, name : String }
type alias Entity = { id : String, startDate : String, endDate : String}
    
type ViewState = FarmListView | FarmView | EntityView
type alias Model = { viewState : ViewState,
                     farmId : String,
                     entityId : String,
                     farmList : List Farm ,
                     entityList : List Entity,
                     farmListTableState : Table.State,
                     entityListTableState : Table.State
                     }

init : ( Model, Cmd Msg )
init =
    ( { viewState = FarmListView,
        farmId = "",
        entityId = "",
        farmList = [],
        entityList = [],
        farmListTableState = Table.initialSort "id",
        entityListTableState = Table.initialSort "id"
      }, fetchFarmListCmd )
