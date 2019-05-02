module Main exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Game exposing (Game, newGame, viewGame)
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (style)


type alias Model =
    { count : Float
    , games : List Game
    }


type Msg
    = Frame Float


view : Model -> Html msg
view model =
    let
        t =
            round model.count
    in
    div []
        (List.append
            (List.map (\g -> Game.viewGame g t) model.games)
            [ p [] [ text "Hello, Player!" ] ])


update msg model =
    case msg of
        Frame _ ->
            ( { model | count = model.count + 1 }, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> ( { count = 0, games = [ newGame ( 400, 225 ), newGame ( 400, 225 ), newGame ( 800, 450 )] }, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> onAnimationFrameDelta Frame
        }
