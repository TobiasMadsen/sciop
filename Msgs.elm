module Msgs exposing (..)

import Http
import Table


-- MESSAGES

type Msg =
    GotoFarmListView |
    GotoFarmView String |
    GotoEntityView String |
    FetchFarmListCompleted (Result Http.Error String) |
    FetchEntityListCompleted (Result Http.Error String) |
    FetchEntityCompleted (Result Http.Error String) |                                                   SetFarmListTableState Table.State |
    SetEntityListTableState Table.State
        
