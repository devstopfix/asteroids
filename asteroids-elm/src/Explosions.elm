module Explosions exposing (Explosion, newExplosion, renderExplosion, updateExplosions)

import Canvas exposing (..)
import Color exposing (Color)
import Point2d exposing (Point2d, coordinates)


type alias Radius =
    Float


type alias Explosion =
    { position : Point2d, color : Color, framesRemaining : Int, radius : Radius }


explosionDuration =
    15


newExplosion : Point2d -> Explosion
newExplosion p =
    { position = p
    , framesRemaining = explosionDuration
    , color = Color.rgba 1 1 1 0.9
    , radius = 40.0
    }


updateExplosions : Float -> List Explosion -> List Explosion
updateExplosions msSincePreviousFrame =
    List.filter isActive << List.map (updateExplosion msSincePreviousFrame)


updateExplosion : Float -> Explosion -> Explosion
updateExplosion msSincePreviousFrame explosion =
    { explosion
        | radius = explosion.radius * 1.05
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
<<<<<<< HEAD

        transformations =
            [tf, translate x y]
    in
    shapes
        [ stroke color, fill color, transform transformations ]
=======
    in
    shapes
        [ stroke color, fill color, transform [ tf, translate x y ] ]
>>>>>>> 91879cd66b9d0c3de899d661c451170870cbbd26
        [ circle ( 0, 0 ) explosion.radius ]
