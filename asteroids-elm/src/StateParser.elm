module StateParser exposing (gameDecoder)

import Debug exposing (..)
import BoundingBox2d exposing (BoundingBox2d, from)
import Circle2d exposing (Circle2d, withRadius)
import Point2d exposing (Point2d, fromCoordinates, origin)

import Json.Decode as Decode exposing (Decoder,succeed, fail, andThen, at, list, map3, map5, field, index, int, maybe, float, string)

type alias GameState = {
      asteroids: Maybe (List AsteroidLocation)
    , bullets: Maybe (List BullletLocation)
    , dimensions : Maybe BoundingBox2d
    , explosions : Maybe (List Point2d)
    , ships : Maybe (List ShipLocation) }

type alias Id = Int

type alias AsteroidLocation = {id: Id, location: Circle2d}

type alias BullletLocation = {id: Id, location: Point2d}

type alias Tag = String

type alias Theta = Float

type alias ShipLocation = {id: Tag, location: Circle2d, theta: Theta}

-- dim : Maybe BoundingBox2d

gameDecoder : Decoder GameState

gameDecoder =
    map5 GameState
        (maybe (field "a" asteroidsDecoder) )
        (maybe (field "b" bulletsDecoder) )
        (maybe (field "dim" dimDecoder) )
        (maybe (field "x" explosionsDecoder) )
        (maybe (field "s" shipsDecoder) )


asteroidsDecoder : Decoder (List AsteroidLocation)
asteroidsDecoder = list asteroidDecoder

asteroidDecoder : Decoder AsteroidLocation
asteroidDecoder =
    field "0" int
        |> andThen (\id -> field "1" float
        |> andThen (\x -> field "2" float
        |> andThen (\y -> field "3" float
        |> andThen (\r -> succeed {location = (withRadius r (fromCoordinates (x, y) ) ), id = id }))))


bulletsDecoder : Decoder (List BullletLocation)
bulletsDecoder = list bulletDecoder

bulletDecoder : Decoder BullletLocation
bulletDecoder =
    field "0" int
        |> andThen (\id -> field "1" float
        |> andThen (\x -> field "2" float
        |> andThen (\y -> succeed { id = id, location = (fromCoordinates (x, y) ) } )))



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

explosionsDecoder : Decoder (List Point2d)
explosionsDecoder = list explosionDecoder

explosionDecoder : Decoder Point2d
explosionDecoder =
    field "0" float
        |> andThen (\x -> field "1" float
        |> andThen (\y -> succeed (fromCoordinates (x, y) ) ))


shipsDecoder : Decoder (List ShipLocation)
shipsDecoder = list shipDecoder

shipDecoder : Decoder ShipLocation
shipDecoder =
    field "0" string
        |> andThen (\tag -> field "1" float
        |> andThen (\x -> field "2" float
        |> andThen (\y -> field "3" float
        |> andThen (\r -> field "4" float
        |> andThen (\theta -> succeed {location = (withRadius r (fromCoordinates (x, y) ) ), id = tag, theta = theta })))))
