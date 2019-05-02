module Game exposing (main)

import Asteroids exposing (Asteroid, newAsteroid)
import Canvas exposing (..)
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes exposing (style)


view : Html msg
view =
    let
        spaceColor =
            Color.rgb255 16 16 16

        asteroid =
            newAsteroid 120.0

        width =
            800

        height =
            510
    in
    Canvas.toHtml ( width, height )
        [ style "border" "2px solid darkred" ]
        [ shapes [ fill spaceColor ] [ rect ( 0, 0 ) width height ]
        , renderAsteroid asteroid
        ]


renderAsteroid asteroid =
    let
        ( x, y ) =
            asteroid.position

        theta =
            asteroid.theta
    in
    shapes
        [ stroke Color.white, fill Color.black, transform [ translate x y, rotate theta ], lineWidth 2.0 ]
        [ asteroid.shape ]


main =
    view
