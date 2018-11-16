module Test.Main where

import Prelude

import Data.Maybe (Maybe(..), isJust)
import Data.String as String
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import Effect.Uncurried as EU
import Node.Process (cwd)
import Test.Unit (suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)
import Toppokki as T

browserWS = "ws://127.0.0.1:9222/devtools/browser/34591418-f82a-49dc-b80e-c848386bdbdf"

getBrowser = do
  -- browser <- T.launch {}
  T.connect { browserWSEndpoint: browserWS }

putBrowser = do
  -- T.close browser
  pure unit


main :: Effect Unit
main = do
  dir <- liftEffect cwd
  tests dir

tests :: String -> Effect Unit
tests dir = runTest do
  suite "toppokki" do
    let crashUrl = T.URL
            $ "file://"
           <> dir
           <> "/test/crash.html"

    test "can screenshot output a loaded page" do
    -- test "can screenshot and pdf output a loaded page" do
      browser <- getBrowser
      page <- T.newPage browser
      T.goto crashUrl page
      content <- T.content page
      Assert.assert "content is non-empty string" (String.length content > 0)
      _ <- T.screenshot {path: "./test/test.png"} page

      -- _ <- T.pdf {path: "./test/test.pdf"} page

      putBrowser

    test "can listen for errors and page load" do
      browser <- getBrowser
      page <- T.newPage browser
      ref <- liftEffect $ Ref.new Nothing
      liftEffect $ T.onPageError (EU.mkEffectFn1 $ (Ref.write <@> ref) <<< Just) page
      T.goto crashUrl page
      value <- liftEffect $ Ref.read ref
      Assert.assert "error occurs from crash.html" $ isJust value
      putBrowser

    test "can wait for selectors" do
      browser <- getBrowser
      page <- T.newPage browser
      ref <- liftEffect $ Ref.new Nothing
      liftEffect $ T.onPageError (EU.mkEffectFn1 $ (Ref.write <@> ref) <<< Just) page
      T.goto crashUrl page
      _ <- T.pageWaitForSelector (T.Selector "h1") {} page
      putBrowser
