module Data exposing (..)

import Dict exposing (Dict)
import Item exposing (..)
import Json.Encode as E
import ListItem
import Login
import NewItem
import Time exposing (Posix)


type alias Flags =
    { user : Maybe User }


type Msg
    = LoginMsg Login.Msg
    | ReceivedItems E.Value
    | ListItemMsg String ListItem.Msg
    | NewItemMsg NewItem.Msg
    | StartAddNew
    | SignOut


type alias Model =
    { user : Maybe User
    , loginModel : Login.Model
    , items : List Item
    , itemModels : Dict String ListItem.Model
    , addingNew : Bool
    , newItem : NewItem.Model
    }


type alias User =
    { email : String }
