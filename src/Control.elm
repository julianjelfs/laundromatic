module Control exposing (..)

import Data exposing (..)
import Dict
import Item
import Json.Decode as D
import ListItem
import Login
import NewItem
import Ports


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { user = flags.user
      , loginModel = Login.init
      , items = []
      , itemModels = Dict.empty
      , addingNew = False
      , newItem = NewItem.init
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoginMsg subMsg ->
            let
                ( subModel, subCmd ) =
                    Login.update subMsg model.loginModel
            in
            ( { model | loginModel = subModel }
            , Cmd.map LoginMsg subCmd
            )

        NewItemMsg subMsg ->
            let
                ( subModel, subCmd, cancel ) =
                    NewItem.update subMsg model.newItem
            in
            ( { model | newItem = subModel, addingNew = not cancel }
            , Cmd.map NewItemMsg subCmd
            )

        ListItemMsg id subMsg ->
            let
                itemModel =
                    Dict.get id model.itemModels

                ( subModel, subCmd ) =
                    case itemModel of
                        Nothing ->
                            ( model.itemModels, Cmd.none )

                        Just itemModel_ ->
                            let
                                ( m, c ) =
                                    ListItem.update subMsg itemModel_
                            in
                            ( Dict.insert id m model.itemModels, c )
            in
            ( { model | itemModels = subModel }
            , Cmd.map (ListItemMsg id) subCmd
            )

        ReceivedItems json ->
            let
                items =
                    D.decodeValue Item.itemsDecoder json
                        |> Result.withDefault []

                itemModels =
                    List.map (\item -> ( item.id, ListItem.init )) items
                        |> Dict.fromList
            in
            ( { model
                | items = items
                , addingNew = False
                , itemModels = itemModels
              }
            , Cmd.none
            )

        StartAddNew ->
            ( { model | addingNew = True }, Cmd.none )

        PauseAll -> 
            ( model, Cmd.none )

        ResumeAll -> 
            ( model, Cmd.none )

        SignOut ->
            ( { model | user = Nothing }, Ports.signOut () )
