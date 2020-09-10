module Item exposing (..)

import Json.Decode as D
import Time exposing (Posix)


type alias Items =
    { items : List Item }


type alias Item =
    { id : String
    , intervalInDays : Int
    , lastWashed : Int
    , name : String
    }


timeTillDue : Posix -> Item -> Int
timeTillDue now item =
    let
        intervalMs =
            item.intervalInDays * 24 * 60 * 60 * 1000

        sinceWash =
            Time.posixToMillis now - item.lastWashed
    in
    intervalMs - sinceWash


itemsDecoder : D.Decoder (List Item)
itemsDecoder =
    D.list itemDecoder


itemDecoder : D.Decoder Item
itemDecoder =
    D.map4 Item
        (D.field "id" D.string)
        (D.field "intervalInDays" D.int)
        (D.field "lastWashed" D.int)
        (D.field "name" D.string)
