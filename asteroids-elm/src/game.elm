module Game exposing (Game, newGame, viewGame)

import Asteroids exposing (Asteroid, newAsteroid)
import Bullets exposing (Bullet, newBullet)
import Canvas exposing (..)
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes exposing (style)


type alias Dimension =
    ( Float, Float )


type alias Game =
    { dimension : Dimension
    , asteroids : List Asteroid
    , bullets : List Bullet
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
        ]
    , bullets =
        [ newBullet 0 ( 1000, 1000 )
        , newBullet 1 ( 2000, 2000 )
        , newBullet 1 ( 3000, 1000 )
        , newBullet 1 ( 2000, 1000 )
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

        space =
            renderSpace game
    in
    Canvas.toHtml ( round width, round height )
        [ style "border" "2px solid darkred" ]
        (List.foldl List.append [] [ asteroids, bullets, space ])


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
