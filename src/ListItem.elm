module ListItem exposing (..)

import Icons.DeleteIcon as Delete
import Icons.WashIcon as Wash
import Icons.Pause as Pause
import Icons.Play as Play
import Icons.Clock as Clock
import Icons.YesIcon as Yes
import Icons.NoIcon as No
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Item exposing (Item)
import Ports


type Confirming
    = NotConfirming
    | ConfirmingDelete
    | ConfirmingWash
    | ConfirmingPause
    | ConfirmingResume


type alias Model =
    { busy : Bool
    , confirming : Confirming
    }


type Msg
    = ConfirmDelete
    | ConfirmWash
    | ConfirmPause
    | ConfirmResume
    | Cancel
    | Delete Item
    | Wash Item
    | Pause Item
    | Resume Item


init : Model
init =
    { busy = False
    , confirming = NotConfirming
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ConfirmDelete ->
            ( { model | confirming = ConfirmingDelete }, Cmd.none )

        ConfirmWash ->
            ( { model | confirming = ConfirmingWash }, Cmd.none )

        ConfirmPause ->
            ( { model | confirming = ConfirmingPause }, Cmd.none )

        ConfirmResume ->
            ( { model | confirming = ConfirmingResume }, Cmd.none )

        Cancel ->
            ( { model | confirming = NotConfirming }, Cmd.none )

        Delete item ->
            ( { model | busy = True }, Ports.deleteItem item )

        Wash item ->
            ( { model | busy = True }, Ports.washItem item )

        Pause item ->
            ( { model | busy = True }, Ports.pauseItem item )

        Resume item ->
            ( { model | busy = True }, Ports.resumeItem item )


confirmView : Msg -> Html Msg
confirmView onConfirm =
    div
        [ class "item -confirm"
        ]
        [ div
            [ class "item__desc -confirm" ]
            [ p [ class "item__title" ] [ text "Are you sure?" ]
            ]
        , button
            [ class "item__action -no"
            , onClick Cancel
            ]
            [No.icon]
        , button
            [ class "item__action -yes"
            , onClick onConfirm
            ]
            [ Yes.icon ]
        ]


view : Item -> Model -> Html Msg
view item model =
    case model.confirming of
        ConfirmingDelete ->
            confirmView (Delete item)

        ConfirmingWash ->
            confirmView (Wash item)

        ConfirmingPause ->
            confirmView (Pause item)

        ConfirmingResume ->
            confirmView (Resume item)

        NotConfirming ->
            let
                paused = item.pausedAt /= Nothing

                pauseAction = if paused then ConfirmResume else ConfirmPause  

                status = 
                    if item.dueInDays == 0 then 
                        Due 
                    else if item.dueInDays < 0 then 
                        Overdue 
                    else 
                        UnderControl

                pluralize n =
                    if n == 1 then
                        " day)"

                    else
                        " days)"
            in
            div
                [ class "item"
                , classList 
                    [ ( "-processing", model.busy ) 
                    , ("-overdue", status == Overdue)
                    , ("-due", status == Due)
                    ]
                ]
                [ div
                    [ class "item__action -delete"
                    , onClick ConfirmDelete
                    ]
                    [ Delete.icon ]
                , div
                    [ class "item__desc" ]
                    [ p [ class "item__title" ]
                        [ span [] [ text <| item.name ]
                        , span [ class "item__interval" ] [ text <| "(" ++ String.fromInt item.intervalInDays ++ pluralize item.intervalInDays ]
                        ]
                    , p [ class "item__subtitle" ] [ text <| dueIn item ]
                    ]
                , button
                    [ class "item__action"
                    , onClick pauseAction
                    , classList [ ( "-paused", paused ), ("-active", not paused)  ]
                    ]
                    [ if paused then Play.icon else Pause.icon ]
                , button
                    [ class "item__action"
                    , onClick ConfirmWash
                    , classList [ ( "-overdue", status == Overdue ), ( "-due", status == Due ) ]
                    ]
                    [ Wash.icon ]
                    
                ]

type Status = UnderControl | Due | Overdue


dueIn : Item -> String
dueIn item =
    case ( String.fromInt item.dueInDays, item.dueInDays < 0 ) of
        ( "0", _ ) ->
            "due today"

        ( "1", _ ) ->
            "due tommorrow"

        ( "-1", _ ) ->
            "due yesterday"

        ( _, True ) ->
            "overdue by " ++ String.fromInt (negate item.dueInDays) ++ " days"

        ( n, False ) ->
            "due in " ++ n ++ " days"
