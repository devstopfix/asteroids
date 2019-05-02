module Game exposing (main)

import Asteroid exposing (newAsteroid)
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
            newAsteroid

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
    shapes
        [ stroke Color.white, fill Color.black, transform [ translate 400 255, rotate 1.5 ], lineWidth 2.0 ]
        [ asteroid ]



main =
    view
