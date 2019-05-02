module Main exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)


import Canvas exposing (..)
import Game exposing (view)
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (style)


type alias Model =
    { count : Float }


type Msg
    = Frame Float

view : Model -> Html Msg
view model =
    div []
        [ p []
            [ --text "Hello, Player!"
              text (String.fromFloat model.count)
            ]
        , Game.view (round model.count // 2)
        , Game.view (round model.count)
        ]

main : Program () Model Msg
main =
    Browser.element
        { init = \() -> ( { count = 0 }, Cmd.none )
        , view = view
        , update =
            \msg model ->
                case msg of
                    Frame _ ->
                        ( { model | count = model.count + 1 }, Cmd.none )
        , subscriptions = \model -> onAnimationFrameDelta Frame
        }