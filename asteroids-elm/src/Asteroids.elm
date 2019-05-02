module Asteroids exposing (Asteroid, newAsteroid)

import Canvas exposing (Point, Shape)
import Points exposing (convertPoints)
import Polygon exposing (pointsToShape)
import Shapes exposing (rockWithRadius)

type alias Id = Int

type alias Theta = Float

type alias Radius = Float

type alias Asteroid = {id: Id, position: Point, theta: Theta, radius: Radius, shape: Shape}

newAsteroid : Point -> Radius -> Asteroid

newAsteroid position radius =
    let
        shape = rockWithRadius radius |> convertPoints |> pointsToShape
    in
        {id = 0,
        position = position,
        theta = 0.0,
        radius = radius,
        shape = shape}
