module Shapes exposing (rockWithRadius)

import Canvas exposing (Shape)
import Point2d exposing (origin)
import Points exposing (readPoints)
import Polygon exposing (polygonToShape)
import Polygon2d exposing (Polygon2d, outerLoop, scaleAbout, singleLoop)
import Rocks exposing (..)


rockWithRadius : RockType -> Float -> Shape
rockWithRadius rt radius =
    let
        rock =
            lookup rt
    in
    scaleAbout origin radius rock |> polygonToShape


classicRockPolygon1 =
    polygon classicRock1


classicRockPolygon2 =
    polygon classicRock2


classicRockPolygon3 =
    polygon classicRock3


classicRockPolygon4 =
    polygon classicRock4


lookup rockType =
    case rockType of
        Classic1 ->
            classicRockPolygon1

        Classic2 ->
            classicRockPolygon2

        Classic3 ->
            classicRockPolygon3

        Classic4 ->
            classicRockPolygon4


polygon : List ( Float, Float ) -> Polygon2d
polygon =
    singleLoop << readPoints
