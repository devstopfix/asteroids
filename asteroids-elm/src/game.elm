module Game exposing (Game, newGame, viewGame)

import Asteroids exposing (Asteroid, newAsteroid)
import Canvas exposing (..)
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes exposing (style)


type alias Dimension =
    ( Float, Float )


type alias Game =
    { dimension : Dimension, asteroids : List Asteroid, spaceColor : Color, transform : Transform }


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
    , asteroids = [ newAsteroid 0 ( 0, 0 ) 60.0,
        newAsteroid 1 ( 2000, 1125 ) 120.0,
        newAsteroid 2 ( 4000, 2250 ) 60.0,
        newAsteroid 3 (    0, 2250 ) 30.0,
        newAsteroid 4 ( 4000,    0 ) 15.0,
        newAsteroid 5 ( 4000 - 30,   30 ) 30.0,
        newAsteroid 6 ( 4000 - 60 - 30,   60 + 30 ) 60.0,
        newAsteroid 7 ( 4000 - 120 - 60 - 30,  120 + 60 + 30 ) 120.0
        ]
    , spaceColor = Color.black
    , transform = scale (canvas_x / game_x) (canvas_y / game_y)
    }


viewGame : Game -> Html msg
viewGame game =
    let
        ( width, height ) =
            game.dimension
    in
    Canvas.toHtml ( round width, round height )
        [ style "border" "2px solid darkred" ]
        (List.append
            [ shapes
                [ fill game.spaceColor ]
                [ rect ( 0, 0 ) width height ]
            ]
            (List.map (\a -> renderAsteroid a game.transform) game.asteroids)
        )



-- [ translate x y, rotate theta ]


renderAsteroid : Asteroid -> Transform -> Renderable
renderAsteroid asteroid tf =
    let
        ( x, y ) =
            asteroid.position
    in
    shapes
        [ stroke Color.white, fill asteroid.color, transform [ tf, translate x y, rotate asteroid.theta ], lineWidth 4.0 ]
        [ asteroid.shape ]
