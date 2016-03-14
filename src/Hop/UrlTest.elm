module Hop.UrlTest (..) where

import Dict
import Hop.Types as Types
import Hop.Url as Url
import ElmTest exposing (..)


urlToLocation =
  let
    empty =
      Url.newUrl

    inputs =
      [ ( "it is empty when empty"
        , empty
        , "#/"
        )
      , ( "it adds the path"
        , { empty | path = "a" }
        , "#/a"
        )
      , ( "it adds the query as pseudo query"
        , { empty | query = Dict.singleton "k" "1" }
        , "#/?k=1"
        )
      , ( "it adds the path and query"
        , { empty | query = Dict.singleton "k" "1", path = "a" }
        , "#/a?k=1"
        )
      ]

    run ( testCase, url, expected ) =
      let
        actual =
          Url.urlToLocation url

        result =
          assertEqual expected actual
      in
        test testCase result
  in
    suite
      "urlToLocation"
      (List.map run inputs)


all : Test
all =
  suite
    "UrlTest"
    [ urlToLocation
    ]