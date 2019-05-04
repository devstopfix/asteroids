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
import StateParser exposing (AsteroidLocation, Graphics, Id)


type alias Dimension =
    ( Float, Float )


type alias Game =
    { dimension : Dimension
    , asteroids : Dict Int Asteroid
    , bullets : List Bullet
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
    , asteroids = Dict.empty |> Dict.insert 1 (newAsteroid 1 (withRadius 120 origin))
    , bullets =
        [ newBullet 0 ( 1000, 1000 )
        , newBullet 1 ( 2000, 2000 )
        ]
    , explosions = [ newExplosion ( 3000, 500 ) ]
    , ships =
        [ newShip "TAG" ( 100, 100 ) (3.14 / 4.0)
        , newShip "WST" ( 3500, 500 ) 3.14
        , newShip "TWN" ( 1440, 1440 ) (3.14 / 2.0)
        ]
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
            renderBullets game.transform game.bullets

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
    { game | asteroids = updateAsteroids graphics.asteroids game.asteroids }


updateAsteroids asteroids game_asteroids =
    -- case maybe_asteroids of
    --     Just asteroids ->
            mergeAsteroids (toAsteroidMap asteroids) game_asteroids

        -- Nothing ->
        --     game_asteroids


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
