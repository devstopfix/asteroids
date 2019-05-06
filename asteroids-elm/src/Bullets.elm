module Bullets exposing (Bullet, newBullet, renderBullet)

import Canvas exposing (..)
import Color exposing (Color)
import Point2d exposing (Point2d, coordinates)


type alias Id =
    Int


type alias Bullet =
    { id : Id, position : Point2d, color : Color, shape : Shape }


newBullet : Id -> Point2d -> Bullet
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
            coordinates bullet.position

        transformations =
            [tf, translate x y]
    in
    shapes
        [ stroke bullet.color, fill bullet.color, transform transformations ]
        [ bullet.shape ]
