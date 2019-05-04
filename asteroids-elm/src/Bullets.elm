module Bullets exposing (Bullet, newBullet, renderBullet)

import Canvas exposing (..)
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


renderBullet : Transform -> Bullet -> Renderable
renderBullet tf bullet =
    let
        ( x, y ) =
            bullet.position
    in
    shapes
        [ stroke bullet.color, fill bullet.color, transform [ tf, translate x y ] ]
        [ bullet.shape ]
