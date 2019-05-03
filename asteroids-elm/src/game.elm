module Game exposing (Game, newGame, viewGame)

import Asteroids exposing (Asteroid, newAsteroid)
import Bullets exposing (Bullet, newBullet)
import Canvas exposing (..)
import Color exposing (Color)
import Explosions exposing (Explosion, newExplosion)
import Html exposing (Html)
import Html.Attributes exposing (style)
import List.FlatMap exposing (flatMap)
import Ships exposing (..)


type alias Dimension =
    ( Float, Float )


type alias Game =
    { dimension : Dimension
    , asteroids : List Asteroid
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
    , asteroids =
        [ newAsteroid 0 ( 0, 0 ) 60.0
        , newAsteroid 1 ( 2000, 1125 ) 120.0
        , newAsteroid 2 ( 4000, 2250 ) 60.0
        , newAsteroid 3 ( 0, 2250 ) 30.0
        , newAsteroid 4 ( 4000, 0 ) 15.0
        , newAsteroid 5 ( 4000 - 30, 30 ) 30.0
        , newAsteroid 6 ( 4000 - 60 - 30, 60 + 30 ) 60.0
        , newAsteroid 7 ( 4000 - 120 - 60 - 30, 120 + 60 + 30 ) 120.0
        , newAsteroid 20 ( 1400, 1440 ) 20.0
        , newAsteroid 24 ( 1480, 1440 ) 20.0
        , newAsteroid 28 ( 1440, 1400 ) 20.0
        , newAsteroid 32 ( 1440, 1480 ) 20.0
        ]
    , bullets =
        [ newBullet 0 ( 1000, 1000 )
        , newBullet 1 ( 2000, 2000 )
        , newBullet 1 ( 3000, 1000 )
        , newBullet 1 ( 2000, 1000 )
        ]
    , explosions = [ newExplosion ( 3000, 500 ) ]
    , ships =
        [ newShip "TAG" ( 100, 100 ) (3.14 / 4.0)
        , newShip "WST" ( 3500, 500 ) 3.14
        , newShip "TWN" ( 1440, 1440 ) (3.14 / 2.0)
        , newShip "NNW" (  400,  400 ) (3 * 3.14 / 4.0)
        , newShip "NNN" (  600,  400 ) (1 * 3.14 / 2.0)
        , newShip "NNE" (  800,  400 ) (1 * 3.14 / 4.0)
        , newShip "WWW" (  400,  600 ) (1 * 3.14 / 1.0)
        , newShip "EEE" (  800,  600 ) (0 * 3.14)
        , newShip "SWW" (  400,  800 ) (5 * 3.14 / 4.0)
        , newShip "SSS" (  600,  800 ) (3 * 3.14 / 2.0)
        , newShip "SSE" (  800,  800 ) (7 * 3.14 / 4.0)
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
            renderAsteroids game.transform game.asteroids

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



-- [ translate x y, rotate theta ]


renderAsteroids : Transform -> List Asteroid -> List Renderable
renderAsteroids tf asteroids =
    List.map (renderAsteroid tf) asteroids


renderAsteroid : Transform -> Asteroid -> Renderable
renderAsteroid tf asteroid =
    let
        ( x, y ) =
            asteroid.position
    in
    shapes
        [ stroke Color.white, fill asteroid.color, transform [ tf, translate x y, rotate asteroid.theta ], lineWidth 4.0 ]
        [ asteroid.shape ]


renderBullets : Transform -> List Bullet -> List Renderable
renderBullets tf bullets =
    List.map (renderBullet tf) bullets


renderBullet : Transform -> Bullet -> Renderable
renderBullet tf bullet =
    let
        ( x, y ) =
            bullet.position
    in
    shapes
        [ stroke bullet.color, fill bullet.color, transform [ tf, translate x y ] ]
        [ bullet.shape ]


renderExplosions : Transform -> List Explosion -> List Renderable
renderExplosions tf explosions =
    List.map (renderExplosion tf) explosions


renderExplosion : Transform -> Explosion -> Renderable
renderExplosion tf explosion =
    let
        ( x, y ) =
            explosion.position

        color =
            explosion.color
    in
    shapes
        [ stroke color, fill color, transform [ tf, translate x y ] ]
        [ circle ( 0, 0 ) explosion.radius ]


renderShips : Transform -> List Ship -> List Renderable
renderShips tf ships =
    List.FlatMap.flatMap (renderSpaceShip tf) ships


renderSpaceShip : Transform -> Ship -> List Renderable
renderSpaceShip tf ship =
    List.append
        [ renderShip tf ship ]
        (renderShipName tf ship)


renderShip : Transform -> Ship -> Renderable
renderShip tf ship =
    let
        ( x, y ) =
            ship.position
    in
    shapes
        [ stroke ship.color, transform [ tf, translate x y, rotate ship.theta ], lineWidth 2.0 ]
        [ ship.shape ]


renderShipName : Transform -> Ship -> List Renderable
renderShipName tf ship =
    let
        ( x, y ) =
            ship.position

        tag =
            ship.id

        color =
            ship.tagColor

        tagTheta =
            ship.theta + (pi / 2)

        tagOffset =
            ship.radius * 3.0
    in
    [ text [ stroke color, fill color, transform [ tf, translate x y, rotate tagTheta, translate -x -y, translate 0 tagOffset], font { size = 36, family = "Source Code Pro" }, align Center ] ( x, y ) tag ]
