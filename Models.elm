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
