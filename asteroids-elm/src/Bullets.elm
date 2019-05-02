module Bullets exposing (Bullet, newBullet)

import Canvas exposing (Point, Shape, circle)
import Color exposing (Color)


type alias Id =
    Int


type alias Bullet =
    { id : Id, position : Point, color : Color, shape : Shape }


newBullet : Id -> Point -> Bullet
newBullet id position =
    { id = id
    , color = Color.rgb255 251 251 255
    , position = position
    , shape = circle ( 0, 0 ) 4
    }
