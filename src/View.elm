module View exposing (..)

import Data exposing (..)
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Item exposing (..)
import ListItem
import Login
import LogoutIcon
import NewItem


view : Model -> Html Msg
view model =
    case model.user of
        Nothing ->
            Html.map LoginMsg (Login.view model.loginModel)

        Just _ ->
            div [ class "app" ]
                [ div
                    [ class "header" ]
                    [ LogoutIcon.icon SignOut
                    , h1 [ class "headline" ]
                        [ text "Laundromatic"
                        ]
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
    button [ class "add-new", onClick StartAddNew ]
        [ text " + " ]
