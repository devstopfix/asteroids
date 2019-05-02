module Asteroids exposing (Asteroid, newAsteroid)

import Canvas exposing (Point, Shape)
import Color exposing (Color)
import Points exposing (convertPoints)
import Polygon exposing (pointsToShape)
import Rocks exposing (..)
import Shapes exposing (rockWithRadius)


type alias Id =
    Int


type alias Theta =
    Float


type alias Radius =
    Float


type alias Asteroid =
    { id : Id, position : Point, theta : Theta, radius : Radius, shape : Shape, color : Color }


newAsteroid : Id -> Point -> Radius -> Asteroid
newAsteroid id position radius =
    let
        rock =
            chooseShape id

        shape =
            rockWithRadius rock radius |> convertToShape
    in
    { id = id
    , position = position
    , theta = 0.0
    , radius = radius
    , shape = shape
    , color = Color.rgb255 4 4 4
    }


convertToShape =
    pointsToShape << convertPoints


chooseShape : Int -> RockType
chooseShape i =
    case modBy 4 i of
        0 ->
            Classic1

        1 ->
            Classic2

        2 ->
            Classic3

        _ ->
            Classic4
