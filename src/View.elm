module View exposing (..)

import Data exposing (..)
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, stopPropagationOn)
import Item exposing (..)
import ListItem
import Login
import Icons.LogoutIcon as Logout
import Icons.New as New
import Icons.Pause as Pause
import Icons.Play as Play
import Json.Decode as Json
import NewItem


view : Model -> Html Msg
view model =
    case model.user of
        Nothing ->
            Html.map LoginMsg (Login.view model.loginModel)

        Just _ ->
            div [ class "app" ]
                [ div
                    [ class "header", onClick Refresh  ]
                    [ div [class "item__action -signout"] [ Logout.icon SignOut]
                    , div [ class "headline"]  [h1 [ class "headline__text" ]
                        [ if model.refreshing then text "Refreshing ..." else text "Laundromatic"
                        ]]
                    , pauseResume model
                    , addNew
                    ]
                , showItems model
                , if model.addingNew then
                    Html.map NewItemMsg (NewItem.view model.newItem)

                  else
                    text ""
                ]


showItems : Model -> Html Msg
showItems model =
    let
        sorted =
            model.items
                |> List.sortBy .dueInDays
    in
    div []
        (List.map
            (\item ->
                let
                    itemModel =
                        Dict.get item.id model.itemModels
                in
                case itemModel of
                    Nothing ->
                        text ""

                    Just m ->
                        Html.map (ListItemMsg item.id) <|
                            ListItem.view item m
            )
            sorted
        )


addNew : Html Msg
addNew =
    div [ class "item__action -new", stopPropagationOn "click" (Json.succeed (StartAddNew, True)) ]
        [ New.icon ]

pauseResume : Model -> Html Msg
pauseResume model =
    let
        paused = Data.allPaused model
        action = if paused then ResumeAll else PauseAll
    in
    div [ class "item__action"
    , classList [("-paused", paused), ("-active", not paused)]
    , stopPropagationOn "click" (Json.succeed (action, True)) ]
        [ if paused then Play.icon else Pause.icon]