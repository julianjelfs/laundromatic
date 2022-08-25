module Icons.Clock exposing (..)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)

icon : Html msg
icon =
    Svg.svg [  viewBox "0 0 24 24", width "24", height "24" ]
    [ Svg.path [ fill "currentColor", d "M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M16.2,16.2L11,13V7H12.5V12.2L17,14.9L16.2,16.2Z" ]
        []
    ]