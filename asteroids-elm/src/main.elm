module Main exposing (main)

import Canvas exposing (..)
import Color
import Game exposing (main)
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (style)


main =
    div []
        [ p []
            [ text "Hello, Player!"
            ]
        , Game.main
        , Game.main
        ]
