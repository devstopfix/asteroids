module Polygon exposing (pointsToShape, polygonToShape)

import Canvas exposing (Point, Shape, lineTo, path)
import Points exposing (closePolygon, convertPoints)
import Polygon2d exposing (Polygon2d, outerLoop)


pointsToShape : List Point -> Shape
pointsToShape points =
    case points of
        [] ->
            path ( 0, 0 ) []

        p0 :: ps ->
            path p0 (List.map (\p -> lineTo p) ps)


polygonToShape : Polygon2d -> Shape
polygonToShape polygon =
    polygon |> outerLoop |> closePolygon |> convertPoints  |> pointsToShape
