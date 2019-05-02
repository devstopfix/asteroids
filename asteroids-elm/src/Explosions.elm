module Explosions exposing (Explosion, newExplosion)

import Canvas exposing (Point)
import Color exposing (Color)

type alias Radius = Float

type alias Explosion =
    { position : Point, color : Color, framesRemaining : Int, radius: Radius }

explosionDuration = 30

newExplosion : Point -> Explosion
newExplosion p =
    { position = p
    , framesRemaining = explosionDuration
    , color = Color.rgba 1 1 0.8 0.8
    , radius = 60.0
    }