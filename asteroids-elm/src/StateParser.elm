module StateParser exposing (gameDecoder)

import BoundingBox2d exposing (BoundingBox2d, from)
import Point2d exposing (fromCoordinates, origin)

import Json.Decode as Decode exposing (Decoder,succeed, fail, andThen, at, list, map2, map3, field, index, int, maybe, float)

type alias GameState = { asteroids: Maybe (List Int)
    , bullets: Maybe (List Int)
    , dimensions : Maybe BoundingBox2d }

-- dim : Maybe BoundingBox2d

gameDecoder : Decoder GameState

gameDecoder =
    map3 GameState
        (maybe (field "a" asteroidDecoder) )
        (maybe (field "b" bulletDecoder) )
        (maybe (field "dim" dimDecoder) )


asteroidDecoder : Decoder (List Int)
asteroidDecoder = list int


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
