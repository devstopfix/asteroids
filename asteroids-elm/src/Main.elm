port module Main exposing (main)

import Asteroids exposing (rotateAsteroids)
import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Debug exposing (log)
import Explosions exposing (updateExplosions)
import Game exposing (Game, newGame, viewGame)
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (style)
import StateParser exposing (gameDecoder)


port graphicsIn : (String -> msg) -> Sub msg


type alias Model =
    { count : Int
    , games : List Game
    }


type Msg
    = Frame Float
    | GraphicsIn String


main : Program () Model Msg
main =
    Browser.element
        { init =
            \() ->
                ( initState
                , Cmd.none
                )
        , view = view
        , update = update
        , subscriptions = \model -> graphicsIn GraphicsIn
        -- , subscriptions = \model -> onAnimationFrameDelta Frame
        }


initState =
    { count = 0
    , games = sampleGames
    }


sampleGames =
    [ newGame ( 800, 450 )
    , newGame ( 400, 225 )
    , newGame ( 400, 225 )
    , newGame ( 200, 112 )
    , newGame ( 200, 112 )
    , newGame ( 200, 112 )
    , newGame ( 200, 112 )
    ]


view : Model -> Html msg
view model =
    let
        t =
            model.count
    in
    div []
        (List.append
            (List.map (\g -> Game.viewGame g) model.games)
            [ p [] [ text "Hello, Player!" ] ]
        )


update msg model =
    case msg of
        Frame _ ->
            ( { model
                | count = model.count + 1
                , games = updateGames model.count model.games
              }
            , Cmd.none
            )

        GraphicsIn state ->
            log state
                ( model, Cmd.none )


updateGames : Int -> List Game -> List Game
updateGames t =
    List.map (updateGame t)


updateGame : Int -> Game -> Game
updateGame t game =
    { game
        | asteroids = rotateAsteroids t game.asteroids
        , explosions = updateExplosions t game.explosions
    }
