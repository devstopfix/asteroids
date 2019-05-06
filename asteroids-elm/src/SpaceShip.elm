module Spaceship exposing (shipWithRadius)

import Canvas exposing (Shape)
import Point2d exposing (origin)
import Points exposing (readPoints)
import Polygon exposing (polygonCentroid, polygonToShape)
import Polygon2d exposing (scaleAbout, singleLoop, translateBy)
import Vector2d exposing (from)


shipWithRadius : Float -> Shape
shipWithRadius r =
    arcadeShipEast |> scaleAbout origin r |> polygonToShape


arcadeShipEast =
    [ ( 24, 0 ), ( -24, -16 ), ( -16, -8 ), ( -16, 8 ), ( -24, 16 ), ( 24, 0 ) ]
        |> readPoints
        |> singleLoop
        |> scaleAbout origin (1.0 / 24.0)
        |> centreAboutMass


centreAboutMass ship =
    case polygonCentroid ship of
        Nothing ->
            ship

        Just c ->
            translateBy (from c origin) ship
