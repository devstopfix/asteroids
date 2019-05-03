module SpaceShip exposing (shipWithRadius)

import Canvas exposing (Shape)
import Point2d exposing (origin)
import Points exposing (readPoints)
import Polygon exposing (pointsToShape, polygonToShape)
import Polygon2d exposing (scaleAbout, singleLoop, outerLoop)

shipWithRadius: Float -> Shape
shipWithRadius r =
    arcadeShipEast |> scaleAbout origin r |> polygonToShape

arcadeShipEast =
    [ ( 24, 0 ), ( -24, -16 ), ( -16, -8 ), ( -16, 8 ), (-24, 16), (24, -0) ]
    |> readPoints
    |> singleLoop
    |> scaleAbout origin (1.0 / 24.0)

-- TODO translate to center of mass