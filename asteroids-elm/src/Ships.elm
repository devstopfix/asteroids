module Ships exposing (Ship, newShip, renderShip, renderTag)

import Canvas exposing (..)
import Circle2d exposing (Circle2d, centerPoint, radius)
import Color exposing (Color)
import Point2d exposing (coordinates)
import Spaceship exposing (shipWithRadius)


type alias Id =
    String


type alias Radius =
    Float


type alias Theta =
    Float


type alias Ship =
    { id : Id, position : Circle2d, theta : Theta, color : Color, tagColor : Color, shape : Shape }


shipRadius : Radius
shipRadius =
    20.0


newShip : Id -> Circle2d -> Theta -> Ship
newShip id position theta =
    { id = id
    , color = Color.rgb255 251 255 251
    , tagColor = Color.rgba 1 1 1 0.8
    , position = position
    , shape = shipWithRadius (radius position)
    , theta = theta
    }


renderShip : Transform -> Ship -> Renderable
renderShip tf ship =
    let
        ( x, y ) =
            coordinates (centerPoint ship.position)
    in
    shapes
        [ stroke ship.color, transform [ tf, translate x y, rotate ship.theta ], lineWidth 2.0 ]
        [ ship.shape ]


renderTag : Transform -> Ship -> List Renderable
renderTag tf ship =
    let
        ( x, y ) =
            coordinates (centerPoint ship.position)

        tag =
            trimTag ship.id

        color =
            ship.tagColor

        tagTheta =
            offset90deg ship.theta

        tagDY =
            tagOffset (radius ship.position)
    in
    [ text [ stroke color, fill color, transform [ tf, translate x y, rotate tagTheta, translate -x -y, translate 0 tagDY ], font { size = 36, family = tagFont }, align Center ] ( x, y ) tag ]


offset90deg =
    (+) (pi / 2)


tagOffset =
    (*) 3.0


tagFont =
    "Source Code Pro,monospace"


trimTag =
    String.left 3 << String.trim
