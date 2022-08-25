module Data exposing (..)

import Dict exposing (Dict)
import Item exposing (..)
import Json.Encode as E
import ListItem
import Login
import NewItem


type alias Flags =
    { user : Maybe User }


type Msg
    = LoginMsg Login.Msg
    | ReceivedItems E.Value
    | ListItemMsg String ListItem.Msg
    | NewItemMsg NewItem.Msg
    | StartAddNew
    | ResumeAll
    | PauseAll
    | SignOut


type alias Model =
    { user : Maybe User
    , loginModel : Login.Model
    , items : List Item
    , itemModels : Dict String ListItem.Model
    , addingNew : Bool
    , newItem : NewItem.Model
    }

allPaused: Model -> Bool
allPaused { items } = List.all (\item -> item.pausedAt /= Nothing) items



type alias User =
    { email : String }
