module Asteroids exposing (Asteroid, newAsteroid, rotateAsteroids)

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
    { id : Id, position : Point, theta : Theta, theta0 : Theta, radius : Radius, shape : Shape, color : Color }


newAsteroid : Id -> Point -> Radius -> Asteroid
newAsteroid id position radius =
    let
        rock =
            chooseShape id

        shape =
            rockWithRadius rock radius
    in
    { id = id
    , position = position
    , theta = 0.0
    , theta0 = thetaOffset id
    , radius = radius
    , shape = shape
    , color = Color.rgb255 4 4 4
    }


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


rotateAsteroids : Int -> List Asteroid -> List Asteroid
rotateAsteroids t asteroids =
    let
        theta =
            cycle t
    in
    List.map (rotateAsteroid theta) asteroids


rotateAsteroid : Theta -> Asteroid -> Asteroid
rotateAsteroid theta asteroid =
    { asteroid | theta = theta + asteroid.theta0 }


cycle : Int -> Theta
cycle t =
    let
        framesPerRevolution =
            960

        n =
            modBy framesPerRevolution t

        f =
            toFloat n / framesPerRevolution
    in
    f * 2 * pi


thetaOffset: Int -> Theta
thetaOffset n =
    let
        two_pi = 314
    in
        toFloat (modBy two_pi n) / two_pi
