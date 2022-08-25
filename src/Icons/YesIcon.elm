module Icons.YesIcon exposing (..)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


icon : Html msg
icon =
    Svg.svg [ viewBox "0 0 24 24", width "24", height "24" ]
        [ Svg.path [ fill "currentColor", d "M12 2C6.5 2 2 6.5 2 12S6.5 22 12 22 22 17.5 22 12 17.5 2 12 2M12 20C7.59 20 4 16.41 4 12S7.59 4 12 4 20 7.59 20 12 16.41 20 12 20M16.59 7.58L10 14.17L7.41 11.59L6 13L10 17L18 9L16.59 7.58Z" ]
            []
        ]