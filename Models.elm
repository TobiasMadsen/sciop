module Models exposing (..)

import Commands exposing (..)
import Msgs exposing (..)

import Table

-- MODEL

type alias Farm = { id : String, name : String }
type alias EntityListElem = { id : String, startDate : String, endDate : String}
type alias TemperatureMeasurement = { time : String, measurement : Int}
type alias WeightMeasurement = { time : String, measurement : Int}
type alias Entity = { status : String,
                      startDate : String,
                      endDate : String,
                      sex : String,
                      ageDays : Int,
                      temperatures : List TemperatureMeasurement,
                      weights : List WeightMeasurement
                    }
defaultEntity = { status = "", startDate = "", endDate = "", sex = "", ageDays = 0, temperatures = [], weights = []}
    
type ViewState = FarmListView | FarmView | EntityView
type alias Model = { viewState : ViewState,
                     farmId : String,
                     entityId : String,
                     farmList : List Farm ,
                     entityList : List EntityListElem,
                     farmListTableState : Table.State,
                     entityListTableState : Table.State,
                     entity : Entity
                     }


    
init : ( Model, Cmd Msg )
init =
    ( { viewState = FarmListView,
        farmId = "",
        entityId = "",
        farmList = [],
        entityList = [],
        farmListTableState = Table.initialSort "id",
        entityListTableState = Table.initialSort "id",
        entity = defaultEntity
      }, fetchFarmListCmd )
