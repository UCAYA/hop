-- Attempt to make my own StartApp alternative

module App where

import Html as H
import Html.Events
import Debug

import StartApp
import Effects exposing (Effects, Never)
import Html.Attributes exposing (href)

type alias AppModel = {
  count: Int
}
                      
zeroModel: AppModel
zeroModel =
  {
    count = 1
  }

type Action
  = ChangeRoute String
  | Increment
  | NoOp

init: (AppModel, Effects Action)
init =
  (zeroModel, Effects.none)

update: Action -> AppModel -> (AppModel, Effects Action)
update action model =
  case action of
    Increment ->
      ({model | count <- model.count + 1 }, Effects.none)
    _ ->
      (model, Effects.none)

view: Signal.Address Action -> AppModel -> H.Html
view address model =
  H.div [] [
    H.text "Hello",
    H.text (toString model.count)
    , menu address model
  ]

menu: Signal.Address Action -> AppModel -> H.Html
menu address model =
  H.div [] [
    H.button [ Html.Events.onClick address (ChangeRoute "users.show") ] [
      H.text "Users"
    ],
    H.a [ href "#/users/1" ] [
      H.text "User 1"
    ],
    H.a [ href "#/users/1/edit" ] [
      H.text "User 1 edit"
    ]
  ]

box: Signal.Mailbox Action
box =
  Signal.mailbox NoOp

modelEffectSignal: Signal (AppModel, Effects Action)
modelEffectSignal =
  Signal.foldp update zeroModel box.signal

viewSignal: Signal H.Html
viewSignal =
  Signal.map (view box.address) modelEffectSignal

--app =
  --StartApp.start {
  --  init = init,
  --  update = update,
  --  view = (view routerMailbox.address),
  --  inputs = []
  --}

--routerMailbox: Signal.Mailbox RouteAction
--routerMailbox = Signal.mailbox NoOp

--debugSignal: Signal (a -> a)
--debugSignal =
--  Signal.map Debug.watch (Signal.map toString routerMailbox.signal)
  --Signal.map (Debug.watch toString) routerMailbox.signal

--debugSignalFw =
--  Signal.forwardTo 

--port fooPort: Signal String
--port fooPort =
--  Signal.map toString debugSignal

{-
 1. click button
 2. send hash change message to address in routerMailbox
 3. mailbox sends change signal
 4. change hash

 5. React to hash change
 6. send signal with changed address
 7. update route model
 8. update views (need to receive route model)
-}

main: Signal H.Html
main =
  viewSignal
  

