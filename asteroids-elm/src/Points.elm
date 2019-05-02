module Points exposing (convertPoints, closePolygon)

import Canvas exposing (Point)
import Point2d exposing (Point2d, coordinates)


p2p : Point2d -> Point
p2p p =
    let
        ( x, y ) =
            coordinates p
    in
    ( x, y )

-- Convert from Geometry points to Canvas points
convertPoints : List Point2d -> List Point
convertPoints ps =
    List.map p2p ps

-- Duplicate the first point as the last point to close the polygon
closePolygon : List Point2d -> List Point2d
closePolygon list =
    case list of
        [] ->
            []
        p :: ps ->
            List.append (p :: ps) [p]
