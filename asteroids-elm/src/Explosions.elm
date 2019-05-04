module Explosions exposing (Explosion, newExplosion, renderExplosion, updateExplosions)

import Canvas exposing (..)
import Color exposing (Color)
import Point2d exposing (Point2d, coordinates)


type alias Radius =
    Float


type alias Opacity =
    Float


type alias Explosion =
    { position : Point2d, color : Color, framesRemaining : Int, radius : Radius, opacity : Opacity }


explosionDuration =
    20


newExplosion : Point2d -> Explosion
newExplosion p =
    { position = p
    , framesRemaining = explosionDuration
    , color = Color.rgba 1 1 0.8 0.8
    , radius = 60.0
    , opacity = 0.98
    }


updateExplosions : Int -> List Explosion -> List Explosion
updateExplosions t =
    List.filter isActive << List.map (updateExplosion t)


updateExplosion : Int -> Explosion -> Explosion
updateExplosion t explosion =
    { explosion
        | radius = explosion.radius * 1.05
        , framesRemaining = explosion.framesRemaining - 1
        , opacity = explosion.opacity * 0.99
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
        [ stroke color, fill color, transform [ tf, translate x y ] ]
        [ circle ( 0, 0 ) explosion.radius ]
