module Hop (new) where

{-| A router for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Setup
@docs new

-}

import History
import Hop.Matchers as Matchers
import Hop.Types exposing (..)
import Hop.Location exposing (fullPathTransformer)


---------------------------------------
-- SETUP


{-|
Create a Router

    router =
      Hop.new {
        matchers = matchers,
        notFound = NotFound
      }
-}
new : Config routeTag -> Router routeTag
new config =
  { run = History.setPath ""
  , signal = routeTagAndQuerySignal config
  }



---------------------------------------
-- UTILS
{-
@private
Each time the hash is changed get a signal
We pass this signal to the main application
-}
--actionTagSignal : Config actionTag routeTag -> Signal actionTag
--actionTagSignal config =
--  Signal.map config.action (routeTagAndQuerySignal config)
--matchLocation : List (PathMatcher route) -> route -> String -> ( route, Location )

routeTagAndQuerySignal : Config routeTag -> Signal ( routeTag, Location )
routeTagAndQuerySignal config =
  let
    eventStream =
      case config.locationConfig of
        Hash -> History.hash
        Path -> History.path
    resolve location =
      location
      |> fullPathTransformer config.locationConfig
      |> Matchers.matchLocation config.matchers config.notFound

  in
    Signal.map resolve eventStream
