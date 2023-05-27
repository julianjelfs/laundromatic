module Item exposing (..)

import Json.Decode as D


type alias Items =
    { items : List Item }


type alias Item =
    { id : String
    , intervalInDays : Int
    , dueInDays : Int
    , name : String
    , pausedAt: Maybe Int
    }


itemsDecoder : D.Decoder (List Item)
itemsDecoder =
    D.list itemDecoder


itemDecoder : D.Decoder Item
itemDecoder =
    D.map5 Item
        (D.field "id" D.string)
        (D.field "intervalInDays" D.int)
        (D.field "dueInDays" D.int)
        (D.field "name" D.string)
        (D.map (\d -> if d == Just 0 then Nothing else d) (D.maybe (D.field "pausedAt" D.int)))
