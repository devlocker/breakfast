---
layout: default
---

# Elm

## Install Dependencies
Get and install [Elm](http://elm-lang.org/install).


Install elm-brunch plugin and elm dependencies:

~~~
npm install --save elm-brunch
elm package install
~~~

Create an `elm` folder in `app/frontend/js/`. This is where any Elm code will
go.

Configure plugin:

~~~javascript
plugins: {
  elmBrunch: {
    mainModule: ['app/frontend/js/elm/Main.elm'],
    outputFile: 'elm.js',
    outputFolder: "public/assets/"
  },
  ...
~~~

This configures the plugin to look for a file called `Main.elm` inside the
folder that was just created. The output file goes into `public/assets/elm.js`.


## First Elm File

Create the file `app/frontend/js/elm/Main.elm`. Populate it with the following
code snippet:

~~~
module Main exposing (main)

import Html exposing (div, h1, ul, li, a, text)
import Html.Attributes exposing (id, href)

main =
  div [ id "content" ]
    [ h1 [] []
    , ul []
        [ li [] [ a [ href "https://github.com/devlocker/breakfast" ] [ text "Breakfast Gem" ] ]
        , li [] [ a [ href "http://elm-lang.org/" ] [ text "Elm Docs" ] ]
        ]
    ]
~~~~

## Display it
Add the compiled `elm.js` file in the `head` of part of the html.

~~~erb
<%= javascript_include_tag "app.js" %>
<%= javascript_include_tag "elm.js" %>
<%= breakfast_autoreload_tag %>
~~~

Execute the Elm code:

~~~html
<script>
  Elm.Main.fullscreen();
</script>
~~~

And that is it!

![react-example]({{ site.baseurl }}/images/examples/elm-1.png)
