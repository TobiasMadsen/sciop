module App exposing (..)

import Config exposing (api)
import Models exposing (..)
import Commands exposing(..)
import Msgs exposing (..)
import Update exposing (..)
import View exposing (..)

import Html exposing (program)

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
