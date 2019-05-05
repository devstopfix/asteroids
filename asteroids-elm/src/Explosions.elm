module Explosions exposing (Explosion, newExplosion, renderExplosion, updateExplosions)

import Canvas exposing (..)
import Color exposing (Color)
import Point2d exposing (Point2d, coordinates)


type alias Radius =
    Float



type alias Explosion =
    { position : Point2d, color : Color, framesRemaining : Int, radius : Radius}


explosionDuration =
    20


newExplosion : Point2d -> Explosion
newExplosion p =
    { position = p
    , framesRemaining = explosionDuration
    , color = Color.rgb255 4 185 235
    , radius = 30.0
    }


updateExplosions : Int -> List Explosion -> List Explosion
updateExplosions t =
    List.filter isActive << List.map (updateExplosion t)


updateExplosion : Int -> Explosion -> Explosion
updateExplosion t explosion =
    { explosion
        | radius = explosion.radius * 1.13
        , framesRemaining = explosion.framesRemaining - 1
    }


isActive e =
    e.framesRemaining > 0


renderExplosion : Transform -> Explosion -> Renderable
renderExplosion tf explosion =
    let
        ( x, y ) =
            coordinates explosion.position

        color =
            explosion.color
    in
    shapes
        [ stroke color, lineWidth 16.0, transform [ tf, translate x y ] ]
        [ circle ( 0, 0 ) explosion.radius ]
