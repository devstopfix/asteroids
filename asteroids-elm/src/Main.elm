port module Main exposing (main)

import Asteroids exposing (rotateAsteroids)
import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Dict exposing (Dict)
import Explosions exposing (updateExplosions)
import Game exposing (Game, mergeGame, newGame, viewGame)
import GraphicsDecoder exposing (Frame, gameDecoder)
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (style)
import Json.Decode exposing (Error, decodeString)


port graphicsIn : (String -> msg) -> Sub msg


port addGame : (Int -> msg) -> Sub msg


type alias Model =
    Dict Int Game


type Msg
    = Frame Float
    | GraphicsIn String
    | AddGame Int


main : Program () Model Msg
main =
    Browser.element
        { init =
            \() -> cmdNone Dict.empty
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ graphicsIn GraphicsIn
        , onAnimationFrameDelta Frame
        , addGame AddGame
        ]


view : Model -> Html msg
view games =
    div []
        (List.map Game.viewGame (Dict.values games))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg games =
    case msg of
        Frame msSincePreviousFrame ->
            cmdNone
                (Dict.map (updateGame msSincePreviousFrame) games)

        GraphicsIn frame_json ->
            cmdNone
                (Dict.update 1 (Maybe.map (mergeGraphics frame_json)) games)

        AddGame id ->
            let
                game =
                    newGame ( 1400, 788 )
            in
            cmdNone (Dict.insert id game games)


mergeGraphics : String -> Game -> Game
mergeGraphics state_json game =
    case Json.Decode.decodeString gameDecoder state_json of
        Ok frame ->
            mergeGame frame game

        Err _ ->
            game


updateGame : Float -> Int -> Game -> Game
updateGame msSincePreviousFrame game_id game =
    { game
        | asteroids = rotateAsteroids msSincePreviousFrame game.asteroids
        , explosions = updateExplosions msSincePreviousFrame game.explosions
    }


cmdNone msg =
    ( msg, Cmd.none )
