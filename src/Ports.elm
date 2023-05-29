port module Ports exposing (..)

import Item exposing (..)
import Json.Encode as E


port signIn : ( String, String ) -> Cmd msg


port signOut : () -> Cmd msg


port addNewItem : ( String, Int, Int ) -> Cmd msg

port refresh : () -> Cmd msg


port washItem : Item -> Cmd msg

port pauseItem : Item -> Cmd msg

port resumeItem : Item -> Cmd msg


port deleteItem : Item -> Cmd msg


port signInError : (String -> msg) -> Sub msg


port addNewError : (String -> msg) -> Sub msg

port receivedItems : (E.Value -> msg) -> Sub msg
