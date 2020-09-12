module Item exposing (..)

import Json.Decode as D
import Time exposing (Posix)


type alias Items =
    { items : List Item }


type alias Item =
    { id : String
    , intervalInDays : Int
    , dueInDays : Int
    , name : String
    }


itemsDecoder : D.Decoder (List Item)
itemsDecoder =
    D.list itemDecoder


itemDecoder : D.Decoder Item
itemDecoder =
    D.map4 Item
        (D.field "id" D.string)
        (D.field "intervalInDays" D.int)
        (D.field "dueInDays" D.int)
        (D.field "name" D.string)
