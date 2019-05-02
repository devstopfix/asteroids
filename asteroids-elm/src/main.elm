module Main exposing (main)

import Asteroids exposing (rotateAsteroids)
import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Game exposing (Game, newGame, viewGame)
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (style)


type alias Model =
    { count : Int
    , games : List Game
    }


type Msg
    = Frame Float


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
            ( { model | count = (model.count + 1), games = (updateGames model.games model.count) }
            , Cmd.none
            )


main : Program () Model Msg
main =
    Browser.element
        { init =
            \() ->
                ( { count = 0
                  , games =
                        [ newGame ( 800, 450 )
                        , newGame ( 400, 225 )
                        , newGame ( 400, 225 )
                        , newGame ( 200, 112 )
                        , newGame ( 200, 112 )
                        , newGame ( 200, 112 )
                        , newGame ( 200, 112 )
                        ]
                  }
                , Cmd.none
                )
        , view = view
        , update = update
        , subscriptions = \model -> onAnimationFrameDelta Frame
        }


updateGames : List Game -> Int -> List Game
updateGames games t =
    List.map (updateGame t) games


updateGame : Int -> Game -> Game
updateGame t game =
    { game | asteroids = rotateAsteroids t game.asteroids }
