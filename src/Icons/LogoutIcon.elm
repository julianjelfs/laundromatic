module Icons.LogoutIcon exposing (..)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (onClick)


icon : msg -> Html msg
icon msg =
    Svg.svg [ onClick msg, viewBox "0 0 24 24", width "24", height "24" ]
        [ Svg.path [ fill "currentColor", d "M16,17V14H9V10H16V7L21,12L16,17M14,2A2,2 0 0,1 16,4V6H14V4H5V20H14V18H16V20A2,2 0 0,1 14,22H5A2,2 0 0,1 3,20V4A2,2 0 0,1 5,2H14Z" ]
            []
        ]
