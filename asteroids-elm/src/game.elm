module Game exposing (main)

import Canvas exposing (..)
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes exposing (style)


view : Html msg
view =
    let
        width =
            400

        height =
            255
    in
    Canvas.toHtml ( width, height )
        [ style "border" "2px solid darkred" ]
        [ text [ align Center ] ( 50, 50 ) "Hello player"
        , shapes [] [ circle (0, 0) 100 ]
        ]

        -- [ style "border" "2px solid darkred" ]
        -- [ shapes [ fill Color.black ] [ rect ( 0, 0 ) width height ]
        --     , shapes [ fill Color.darkCharcoal] [ rect ( 100, 100 ) width height ]
        --     , shapes [] [ circle (0, 0) 100 ]
        -- , renderSquare
        -- ]


renderSquare =
    shapes
        [ fill (Color.rgba 0 0 0 0.5)
        , stroke Color.red ]
        [ rect ( 0, 0 ) 100 50 ]


main =
    view
