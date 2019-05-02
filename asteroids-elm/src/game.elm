module Game exposing (Game, viewGame, newGame)

import Asteroids exposing (Asteroid, newAsteroid)
import Canvas exposing (..)
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes exposing (style)


type alias Dimension = (Float, Float)

type alias Game = {dimension: Dimension, asteroids: List Asteroid, spaceColor: Color}


newGame : Game
newGame =
    {
        dimension = (800, 510),
        asteroids = [newAsteroid 120.0],
        spaceColor = Color.rgb255 16 16 16
    }


viewGame : Game -> Int -> Html msg
viewGame game t =
    let
        (width, height)
            = game.dimension
    in
    Canvas.toHtml ( round width, round height )
        [ style "border" "2px solid darkred" ]
        (List.append
            [ shapes
                [ fill game.spaceColor ]
                [ rect ( 0, 0 ) width height ]
            ]
            (List.map (\a -> renderAsteroid a t) game.asteroids))


cycle : Int -> Float
cycle t =
    let
        framesPerRevolution =
            240

        n =
            modBy framesPerRevolution t

        f =
            toFloat n / framesPerRevolution
    in
    f * 2 * pi


renderAsteroid asteroid t =
    let
        ( x, y ) =
            asteroid.position

        theta =
            cycle(t)
    in
    shapes
        [ stroke Color.white, fill Color.black, transform [ translate x y, rotate theta ], lineWidth 2.0 ]
        [ asteroid.shape ]
