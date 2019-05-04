module Game exposing (Game, mergeGame, newGame, viewGame)

import Asteroids exposing (..)
import Bullets exposing (Bullet, newBullet, renderBullet)
import Canvas exposing (..)
import Circle2d exposing (Circle2d, withRadius)
import Color exposing (Color)
import Dict exposing (Dict)
import Explosions exposing (Explosion, newExplosion, renderExplosion)
import Html exposing (Html)
import Html.Attributes exposing (style)
import List.FlatMap exposing (flatMap)
import Point2d exposing (origin)
import Ships exposing (..)
import StateParser exposing (AsteroidLocation, BulletLocation, Graphics, Id)


type alias Dimension =
    ( Float, Float )


type alias Game =
    { dimension : Dimension
    , asteroids : Dict Int Asteroid
    , bullets : Dict Int Bullet
    , explosions : List Explosion
    , ships : List Ship
    , spaceColor : Color
    , transform : Transform
    }


gameDimensions =
    ( 4000.0, 2250.0 )


newGame : Dimension -> Game
newGame dims =
    let
        ( canvas_x, canvas_y ) =
            dims

        ( game_x, game_y ) =
            gameDimensions
    in
    { dimension = dims
    , asteroids = Dict.empty
    , bullets = Dict.empty
    , explosions = [ newExplosion ( 3000, 500 ) ]
    , ships = []
    , spaceColor = Color.black
    , transform = scale (canvas_x / game_x) (canvas_y / game_y)
    }


viewGame : Game -> Html msg
viewGame game =
    let
        ( width, height ) =
            game.dimension

        asteroids =
            renderAsteroids game.transform (Dict.values game.asteroids)

        bullets =
            renderBullets game.transform (Dict.values game.bullets)

        explosions =
            renderExplosions game.transform game.explosions

        ships =
            renderShips game.transform game.ships

        tags =
            renderTags game.transform game.ships

        space =
            renderSpace game
    in
    Canvas.toHtml ( round width, round height )
        [ style "border" "2px solid darkred" ]
        (List.foldl List.append [] [ explosions, asteroids, ships, bullets, tags, space ])


renderSpace : Game -> List Renderable
renderSpace game =
    let
        ( width, height ) =
            game.dimension
    in
    [ shapes
        [ fill game.spaceColor ]
        [ rect ( 0, 0 ) width height ]
    ]


renderAsteroids tf =
    List.map (renderAsteroid tf)


renderBullets tf =
    List.map (renderBullet tf)


renderExplosions tf =
    List.map (renderExplosion tf)


renderTags tf =
    flatMap (renderTag tf)


renderShips tf =
    List.map (renderShip tf)


mergeGame : Game -> Graphics -> Game
mergeGame game graphics =
    { game | asteroids = updateAsteroids graphics.asteroids game.asteroids
    , bullets = updateBullets graphics.bullets game.bullets }


updateAsteroids asteroids game_asteroids =
            mergeAsteroids (toAsteroidMap asteroids) game_asteroids


toAsteroidMap : List AsteroidLocation -> Dict Id AsteroidLocation
toAsteroidMap =
    Dict.fromList << List.map (\a -> ( a.id, a ))


mergeAsteroids : Dict Int AsteroidLocation -> Dict Int Asteroid -> Dict Int Asteroid
mergeAsteroids graphics_asteroids game_asteroids =
    Dict.merge
        (\id a -> Dict.insert id (newAsteroid id a.location))
        (\id a b -> Dict.insert id { b | position = a.location })
        (\id _ -> identity) -- Remove
        graphics_asteroids
        game_asteroids
        Dict.empty


updateBullets bullets game_bullets =
            mergeBullets (toBulletMap bullets) game_bullets

toBulletMap : List BulletLocation -> Dict Id BulletLocation
toBulletMap =
    Dict.fromList << List.map (\a -> ( a.id, a ))


mergeBullets : Dict Int BulletLocation -> Dict Int Bullet -> Dict Int Bullet
mergeBullets graphics_bullets game_bullets =
    Dict.merge
        (\id a -> Dict.insert id (newBullet id a.location))
        (\id a b -> Dict.insert id { b | position = a.location })
        (\id _ -> identity)
        graphics_bullets
        game_bullets
        Dict.empty
