module Icons.DeleteIcon exposing (..)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


icon : Html msg
icon =
    Svg.svg [ viewBox "0 0 24 24", width "20", height "20" ]
        [ Svg.path [ fill "currentColor", d "M19,4H15.5L14.5,3H9.5L8.5,4H5V6H19M6,19A2,2 0 0,0 8,21H16A2,2 0 0,0 18,19V7H6V19Z" ]
            []
        ]
