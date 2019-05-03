module Shapes exposing (rockWithRadius)

import Point2d exposing (Point2d, fromCoordinates, origin)
import Points exposing (closePolygon, readPoints)
import Polygon2d exposing (Polygon2d, outerLoop, scaleAbout, singleLoop)
import Rocks exposing (..)


rockWithRadius : RockType -> Float -> List Point2d
rockWithRadius rt radius =
    let
        rock =
            lookup rt
    in
    scaleAbout origin radius rock |> outerLoop |> closePolygon



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

polygon =
    singleLoop << readPoints
