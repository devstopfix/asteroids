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
    , asteroids = [ newAsteroid ( 0, 0 ) 60.0, newAsteroid ( 2000, 1125 ) 120.0, newAsteroid ( 4000, 2250 ) 60.0 ]
    , spaceColor = Color.black
    , transform = scale (canvas_x / game_x) (canvas_y / game_y)
    }


viewGame : Game -> Int -> Html msg
viewGame game t =
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
            (List.map (\a -> renderAsteroid a t game.transform) game.asteroids)
        )


cycle : Int -> Float
cycle t =
    let
        framesPerRevolution =
            480

        n =
            modBy framesPerRevolution t

        f =
            toFloat n / framesPerRevolution
    in
    f * 2 * pi



-- [ translate x y, rotate theta ]


renderAsteroid : Asteroid -> Int -> Transform -> Renderable
renderAsteroid asteroid t tf =
    let
        ( x, y ) =
            asteroid.position

        theta =
            cycle t
    in
    shapes
        [ stroke Color.white, fill asteroid.color, transform [ tf, translate x y, rotate theta ], lineWidth 2.0 ]
        [ asteroid.shape ]
