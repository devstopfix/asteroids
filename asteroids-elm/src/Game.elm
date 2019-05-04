module Game exposing (Game, mergeGame, newGame, viewGame)

import Asteroids exposing (..)
import Bullets exposing (Bullet, newBullet, renderBullet)
import Canvas exposing (..)
import Color exposing (Color)
import Dict exposing (Dict)
import Explosions exposing (Explosion, newExplosion, renderExplosion)
import Html exposing (Html)
import Html.Attributes exposing (style)
import List.FlatMap exposing (flatMap)
import Ships exposing (..)
import StateParser exposing (Graphics)


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
    , asteroids = Dict.empty
    , bullets =
        [ newBullet 0 ( 1000, 1000 )
        , newBullet 1 ( 2000, 2000 )
        , newBullet 1 ( 400, 400 )
        , newBullet 1 ( 600, 400 )
        , newBullet 1 ( 800, 400 )
        , newBullet 1 ( 400, 600 )
        , newBullet 1 ( 800, 600 )
        , newBullet 1 ( 400, 800 )
        , newBullet 1 ( 600, 800 )
        , newBullet 1 ( 800, 800 )
        ]
    , explosions = [ newExplosion ( 3000, 500 ) ]
    , ships =
        [ newShip "TAG" ( 100, 100 ) (3.14 / 4.0)
        , newShip "WST" ( 3500, 500 ) 3.14
        , newShip "TWN" ( 1440, 1440 ) (3.14 / 2.0)
        , newShip "NNW" ( 400, 400 ) (3 * 3.14 / 4.0)
        , newShip "NNN" ( 600, 400 ) (1 * 3.14 / 2.0)
        , newShip "NNE" ( 800, 400 ) (1 * 3.14 / 4.0)
        , newShip "WWW" ( 400, 600 ) (1 * 3.14 / 1.0)
        , newShip "EEE" ( 800, 600 ) (0 * 3.14)
        , newShip "SWW" ( 400, 800 ) (5 * 3.14 / 4.0)
        , newShip "SSS" ( 600, 800 ) (3 * 3.14 / 2.0)
        , newShip "SSE" ( 800, 800 ) (7 * 3.14 / 4.0)
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

        space =
            renderSpace game
    in
    Canvas.toHtml ( round width, round height )
        [ style "border" "2px solid darkred" ]
        (List.foldl List.append [] [ explosions, asteroids, ships, bullets, space ])


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


renderShips tf =
    List.FlatMap.flatMap (renderSpaceShip tf)


renderSpaceShip : Transform -> Ship -> List Renderable
renderSpaceShip tf ship =
    List.append
        [ renderShip tf ship ]
        (renderTag tf ship)


mergeGame : Game -> Graphics -> Game
mergeGame game graphics =
    game
