module Shapes exposing (rockWithRadius)

import Points exposing (closePolygon)
import Point2d exposing (Point2d, fromCoordinates, origin)
import Polygon2d exposing (scaleAbout, singleLoop, outerLoop)

-- type RockType = Classic1

rockDef1 =
    [ ( 0.5, 1.0 ), ( 1.0, 0.5 ), ( 0.75, 0.0 ), ( 1.0, -0.5 ), ( 0.25, -1.0 ), ( -0.5, -1.0 ), ( -1.0, -0.5 ), ( -1.0, 0.5 ), ( -0.5, 1.0 ), ( 0.0, 0.5 ) ]


points ps =
    List.map (\( x, y ) -> fromCoordinates ( x, y )) ps

rock1 =
    rockDef1 |> points |> singleLoop

rockWithRadius : Float -> List Point2d
rockWithRadius radius =
    (scaleAbout origin radius rock1) |> outerLoop |> closePolygon