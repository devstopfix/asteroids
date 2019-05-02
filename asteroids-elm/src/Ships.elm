module Ships exposing (Ship, newShip)

import Canvas exposing (Point, Shape)
import Color exposing (Color)
import Polygon exposing (pointsToShape)


type alias Id =
    String


type alias Theta =
    Float


type alias Ship =
    { id : Id, position : Point, theta : Theta, color : Color, shape : Shape }


newShip : Id -> Point -> Theta -> Ship
newShip id position theta =
    { id = id
    , color = Color.rgb255 251 255 251
    , position = position
    , shape = shipEast
    , theta = theta
    }


shipEast =
    [ ( -5, 4 ), ( 0, -12 ), ( 5, 4 ), ( -5, 4 ) ] |> pointsToShape
