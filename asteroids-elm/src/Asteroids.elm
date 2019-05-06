module Asteroids exposing (Asteroid, newAsteroid, renderAsteroid, rotateAsteroids)

import Canvas exposing (..)
import Circle2d exposing (Circle2d, centerPoint, radius)
import Color exposing (Color)
import Dict exposing (Dict)
import Point2d exposing (coordinates, origin)
import Points exposing (convertPoints, readPoints)
import Polygon exposing (pointsToShape, polygonToShape)
import Polygon2d exposing (Polygon2d, outerLoop, scaleAbout, singleLoop)


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
    , color = granite
    }



-- https://encycolorpedia.com/2f353b


granite =
    Color.rgb255 5 8 9


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


renderAsteroid : Transform -> Asteroid -> Renderable
renderAsteroid tf asteroid =
    let
        ( x, y ) =
            coordinates (centerPoint asteroid.position)
    in
    shapes
        [ stroke Color.gray, fill asteroid.color, transform [ tf, translate x y, rotate asteroid.theta ], lineWidth 4.0 ]
        [ asteroid.shape ]



-- Arcade shapes http://computerarcheology.com/Arcade/Asteroids/VectorROM.html


type RockType
    = Classic1
    | Classic2
    | Classic3
    | Classic4


classicRock1 =
    [ ( 0.5, 1.0 ), ( 1.0, 0.5 ), ( 0.75, 0.0 ), ( 1.0, -0.5 ), ( 0.25, -1.0 ), ( -0.5, -1.0 ), ( -1.0, -0.5 ), ( -1.0, 0.5 ), ( -0.5, 1.0 ), ( 0.0, 0.5 ) ]


classicRock2 =
    [ ( 1.0, 0.5 ), ( 0.5, 1.0 ), ( 0.0, 0.75 ), ( -0.5, 1.0 ), ( -1.0, 0.5 ), ( -0.75, 0.0 ), ( -1.0, -0.5 ), ( -0.5, -1.0 ), ( -0.25, -0.75 ), ( 0.5, -1.0 ), ( 1.0, -0.25 ), ( 0.5, 0.25 ) ]


classicRock3 =
    [ ( -1.0, -0.25 ), ( -0.5, -1.0 ), ( 0.0, -0.25 ), ( 0.0, -1.0 ), ( 0.5, -1.0 ), ( 1.0, -0.25 ), ( 1.0, 0.25 ), ( 0.5, 1.0 ), ( -0.25, 1.0 ), ( -1.0, 0.25 ), ( -0.5, 0.0 ) ]


classicRock4 =
    [ ( 1.0, 0.25 ), ( 1.0, 0.5 ), ( 0.25, 1.0 ), ( -0.5, 1.0 ), ( -0.25, 0.5 ), ( -1.0, 0.5 ), ( -1.0, -0.25 ), ( -0.5, -1.0 ), ( 0.25, -0.75 ), ( 0.5, -1.0 ), ( 1.0, -0.5 ), ( 0.25, 0.0 ) ]


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
