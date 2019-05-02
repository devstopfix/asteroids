module Game exposing (main)

import Canvas exposing (..)
import Color
import Html exposing (Html)
import Html.Attributes exposing (style)


view : Html msg
view =
    let
        width = 400
        height = 255
    in
        Canvas.toHtml (width, height)
            [ style "border" "1px solid red" ]
            [ shapes [ fill Color.black ] [ rect (0, 0) width height ]
            , renderSquare
            ]



renderSquare =
  shapes [ fill (Color.black) ]
      [ rect (0, 0) 100 50 ]

main = view
