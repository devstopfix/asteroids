module Polygon exposing (pointsToShape)

import Canvas exposing (Point, Shape, lineTo, path)

pointsToShape : List Point -> Shape
pointsToShape points =
    case points of
        [] ->
            path ( 0, 0 ) []

        p0 :: ps ->
            path p0 (List.map (\p -> lineTo p) ps)
