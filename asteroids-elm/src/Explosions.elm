module Explosions exposing (Explosion, newExplosion, updateExplosions)

import Canvas exposing (Point)
import Color exposing (Color)

type alias Radius = Float

type alias Opacity = Float

type alias Explosion =
    { position : Point, color : Color, framesRemaining : Int, radius: Radius, opacity: Opacity }

explosionDuration = 20

newExplosion : Point -> Explosion
newExplosion p =
    { position = p
    , framesRemaining = explosionDuration
    , color = Color.rgba 1 1 0.8 0.8
    , radius = 60.0
    , opacity = 0.98
    }

updateExplosions: Int -> List Explosion -> List Explosion
updateExplosions t explosions =
    List.map (updateExplosion t) explosions
    |> List.filter isActive

updateExplosion : Int -> Explosion -> Explosion
updateExplosion t explosion =
    {explosion | radius = explosion.radius * 1.05
    , framesRemaining = (explosion.framesRemaining - 1)
    , opacity = (explosion.opacity * 0.99 ) }

isActive e = e.framesRemaining > 0