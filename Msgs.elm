module Msgs exposing (..)

import Http
import Table


-- MESSAGES

type Msg =
    GotoFarmListView |
    GotoFarmView String |
    GotoEntityView |
    FetchFarmListCompleted (Result Http.Error String) |
    FetchEntityListCompleted (Result Http.Error String) |
    SetTableState Table.State
