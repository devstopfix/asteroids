module Main exposing (main)

import Canvas exposing (..)
import Color
import Html exposing (Html, text)
import Html.Attributes exposing (style)


view : Html msg
view =
    let
        width = 400
        height = 255
    in
        Canvas.toHtml (width, height)
            [ style "border" "1px solid black" ]
            [ shapes [ fill Color.black ] [ rect (0, 0) width height ]
            , renderSquare
            ]

renderSquare =
  shapes [ fill (Color.rgba 0 0 0 1) ]
      [ rect (0, 0) 100 50 ]

main = view

  -- text "Hello, Player!"