module Icons.Pause exposing (..)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


icon : Html msg
icon =
    Svg.svg [ viewBox "0 0 24 24", width "24", height "24" ]
        [ Svg.path [ fill "currentColor", d "M13,16V8H15V16H13M9,16V8H11V16H9M12,2A10,10 0 0,1 22,12A10,10 0 0,1 12,22A10,10 0 0,1 2,12A10,10 0 0,1 12,2M12,4A8,8 0 0,0 4,12A8,8 0 0,0 12,20A8,8 0 0,0 20,12A8,8 0 0,0 12,4Z" ]
            []
        ]