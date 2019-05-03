module Ships exposing (Ship, newShip)

import Canvas exposing (Point, Shape)
import Color exposing (Color)
import SpaceShip exposing (shipWithRadius)


type alias Id =
    String

type alias Radius =
    Float


type alias Theta =
    Float


type alias Ship =
    { id : Id, position : Point, theta : Theta, color : Color, tagColor : Color, shape : Shape, radius : Radius}


shipRadius : Radius
shipRadius = 20.0

newShip : Id -> Point -> Theta -> Ship
newShip id position theta =
    { id = id
    , color = Color.rgb255 251 255 251
    , tagColor = Color.rgba 1 1 1 0.8
    , position = position
    , radius = shipRadius
    , shape = shipWithRadius shipRadius
    , theta = theta
    }


