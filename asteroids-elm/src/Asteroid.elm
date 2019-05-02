module Asteroid exposing (newAsteroid, asteroidPath)

import Canvas exposing (Point, Shape, lineTo, path)
import Point2d exposing (Point2d, coordinates, fromCoordinates, origin)
import Shapes exposing (rockWithRadius)


p2p : Point2d -> Point
p2p p =
    let
        ( x, y ) =
            coordinates p
    in
    ( x, y )


asteroidPath : List Point2d -> Shape
asteroidPath points =
    case points of
        [] ->
            path (p2p origin) []

        p0 :: ps ->
            path (p2p p0) (List.map (\ p -> lineTo (p2p p) ) ps)

newAsteroid =
    (rockWithRadius 200.0) |> asteroidPath