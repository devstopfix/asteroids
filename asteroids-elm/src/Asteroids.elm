module Asteroids exposing (Asteroid, newAsteroid, renderAsteroid, rotateAsteroids)

import Canvas exposing (..)
import Circle2d exposing (Circle2d, centerPoint, radius)
import Color exposing (Color)
import Dict exposing (Dict)
import Point2d exposing (coordinates)
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
    { id : Id, position : Circle2d, theta : Theta, theta0 : Theta, shape : Shape, color : Color }


newAsteroid : Id -> Circle2d -> Asteroid
newAsteroid id position =
    let
        rock =
            chooseShape id

        shape =
            rockWithRadius rock (radius position)
    in
    { id = id
    , position = position
    , theta = 0.0
    , theta0 = thetaOffset id
    , shape = shape
    , color = Color.rgb255 1 1 1
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


rotateAsteroids : Int -> Dict Int Asteroid -> Dict Int Asteroid
rotateAsteroids t =
    let
        theta =
            cycle t
    in
    Dict.map (rotateAsteroid theta)


rotateAsteroid : Theta -> Int -> Asteroid -> Asteroid
rotateAsteroid theta _ asteroid =
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


thetaOffset : Int -> Theta
thetaOffset n =
    let
        two_pi =
            314
    in
    toFloat (modBy two_pi n) / two_pi


renderAsteroid : List Transform -> Asteroid -> Renderable
renderAsteroid tf asteroid =
    let
        ( x, y ) =
            coordinates (centerPoint asteroid.position)

        transformations =
            List.append tf [ translate x y, rotate asteroid.theta ]
    in
    shapes
        [ stroke Color.gray, fill asteroid.color, transform transformations, lineWidth 4.0 ]
        [ asteroid.shape ]
