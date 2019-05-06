module Bullets exposing (Bullet, mergeBullets, newBullet, renderBullet)

import Canvas exposing (..)
import Color exposing (Color)
import Dict exposing (..)
import Point2d exposing (Point2d, coordinates)
import Vector2d exposing (..)


type alias Id =
    Int


type alias Bullet =
    { id : Id, position : Point2d, tail : Maybe Vector2d, color : Color, shape : Shape }


newBullet : Id -> Point2d -> Bullet
newBullet id position =
    { id = id
    , color = Color.rgb255 251 251 255
    , position = position
    , shape = circle ( 0, 0 ) 4
    , tail = Nothing
    }


renderBullet : Transform -> Bullet -> List Renderable
renderBullet tf bullet =
    List.filterMap identity
        [ renderWarhead tf bullet
        , renderTail tf bullet
        ]


renderWarhead tf bullet =
    let
        ( x, y ) =
            coordinates bullet.position
    in
    Just
        (shapes
            [ stroke bullet.color, fill bullet.color, transform [ tf, translate x y ] ]
            [ bullet.shape ]
        )


renderTail : Transform -> Bullet -> Maybe Renderable
renderTail tf bullet =
    case bullet.tail of
        Just tail ->
            let
                ( ox, oy ) =
                    coordinates bullet.position

                ( x, y ) =
                    components tail
            in
            Just
                (shapes
                    [ stroke tailColor, lineWidth 2.0, transform [ tf ] ]
                    [ path ( ox, oy ) [ lineTo ( ox - x, oy - y ) ] ]
                )

        Nothing ->
            Nothing


mergeBullets graphics_bullets game_bullets =
    Dict.merge
        (\id f -> Dict.insert id (newBullet id f.location))
        (\id f b -> Dict.insert id (mergeBullet f b))
        (\id _ -> identity)
        graphics_bullets
        game_bullets
        Dict.empty


mergeBullet f b =
    let
        tail =
            from b.position f.location
    in
    if squaredLength tail > longestTail then
        { b | position = f.location, tail = Nothing }

    else
        { b | position = f.location, tail = Just tail }


tailColor =
    Color.hsl (199 / 360) 0.96 0.82


longestTail =
    40.0 * 40.0
