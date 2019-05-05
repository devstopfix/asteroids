port module Main exposing (main)

import Asteroids exposing (rotateAsteroids)
import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Dict exposing (Dict)
import Explosions exposing (updateExplosions)
import Game exposing (Game, mergeGame, newGame, viewGame)
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (style)
import Json.Decode exposing (Error, decodeString)
import StateParser exposing (gameDecoder)


port graphicsIn : (String -> msg) -> Sub msg


port addGame : (Int -> msg) -> Sub msg


type alias GameId = Int

type alias Model = Dict GameId Game


type Msg
    = Frame Float
    | GraphicsIn String
    | AddGame Int


main : Program () Model Msg
main =
    Browser.element
        { init =
            \() ->
                ( Dict.empty
                , Cmd.none
                )
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
        (List.map (\g -> Game.viewGame g) (Dict.values games) )


update msg games =
    case msg of
        Frame _ ->
            ( updateGames 0 games
            , Cmd.none
            )

        GraphicsIn state_json ->
            ( Dict.update 1 (Maybe.map (mergeGraphics state_json)) games, Cmd.none )


        AddGame id ->
            let
                game =
                    newGame ( 1400, 788 )
            in
            ( Dict.insert id game games , Cmd.none )


mergeGraphics state_json model =
    case Json.Decode.decodeString StateParser.gameDecoder state_json of
        Ok graphics ->
            mergeGame model graphics

        Err _ ->
            model


updateGames : GameId -> Dict GameId Game -> Dict GameId Game
updateGames t =
    Dict.map (\_ g -> (updateGame t g) )


updateGame : Int -> Game -> Game
updateGame t game =
    { game
        | asteroids = rotateAsteroids t game.asteroids
        , explosions = updateExplosions t game.explosions
    }
