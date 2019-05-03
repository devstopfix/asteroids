module StateParser exposing (gameDecoder)

import Debug exposing (..)
import BoundingBox2d exposing (BoundingBox2d, from)
import Circle2d exposing (Circle2d, withRadius)
import Point2d exposing (fromCoordinates, origin)

import Json.Decode as Decode exposing (Decoder,succeed, fail, andThen, at, list, map3, map4, field, index, int, maybe, float)

type alias GameState = { asteroids: Maybe (List AsteroidLocation)
    , bullets: Maybe (List Int)
    , dimensions : Maybe BoundingBox2d }

type alias Id = Int

type alias AsteroidLocation = {id: Id, location: Circle2d}

-- dim : Maybe BoundingBox2d

gameDecoder : Decoder GameState

gameDecoder =
    map3 GameState
        (maybe (field "a" asteroidsDecoder) )
        (maybe (field "b" bulletDecoder) )
        (maybe (field "dim" dimDecoder) )


asteroidsDecoder : Decoder (List AsteroidLocation)
asteroidsDecoder = list asteroidDecoder

asteroidDecoder : Decoder AsteroidLocation
asteroidDecoder =
    field "0" int
        |> andThen (\id -> field "1" float
        |> andThen (\x -> field "2" float
        |> andThen (\y -> field "3" float
        |> andThen (\r -> succeed {location = (withRadius r (fromCoordinates (x, y) ) ), id = id }))))


bulletDecoder : Decoder (List Int)
bulletDecoder = list int



dimDecoder: Decoder BoundingBox2d
dimDecoder =
    list float |> andThen dimHelp

dimHelp : List Float -> Decoder BoundingBox2d
dimHelp fs =
    case fs of
        [x, y] ->
            succeed (from origin (fromCoordinates (x, y) ) )
        _ ->
            fail "Expecting 2 floats"

-- Decode.decodeString StateParser.gameDecoder "{\"dim\":[1,2,3]}"
