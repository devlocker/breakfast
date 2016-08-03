---
layout: default
---

# The brunch_config
> Brunch relies on solid conventions, reducing your configuration needs to the
> bare minimum.

This is the configuration file for [`brunch`](http://brunch.io/). This comes
preconfigured to just work™. If you would like to learn more about Brunch I
would suggest reading their fantastic [documentation](https://github.com/brunch/brunch-guide).


## Concatenation
Once you start your Rails server Breakfast will have brunch compile your assets
into the `public/assets` folder.

The `files` option tells Brunch where to look for assets and how to combine
them.

~~~javascript
files: {
  javascripts: {
    joinTo: {
      'app.js': /^app\/frontend\/js\//,
      'vendor.js': /^(?!app\/frontend\/js)/
    }
  },
  stylesheets: {
    joinTo: 'app.css'
  }
},
~~~

Looking at this sample configuration, anything in the `app/frontend/js` folder
will get combined into a single file called `app.js`. Everything outside
of it (including other npm packages like jQuery) will get placed into
`vendor.js`.

## Plugins

~~~javascript
plugins: {
  babel: {
    presets: ['es2015']
  },
},
~~~

This is the plugins section. By default Breakfest sets up your project to have
first class support for [ES6](https://github.com/lukehoban/es6features#readme).

## Paths

~~~javascript
paths: {
  watched: [
    "app/frontend",
  ],

  public: "public/assets"
},
~~~

The `paths` options tells Brunch where to look for assets. Breakfast sets the default location to `app/frontend`.

`public/assets` is the location we want Brunch to compile our assets to.

## NPM

~~~javascript
npm: {
  globals: {
    $: "jquery",
    jQuery: "jquery"
  }
}
~~~

This section just exposes some packages to `window`. This way you can use the
package without having an explicit `require`. See the [official
docs](http://brunch.io/docs/js-modules-npm.html) for more information.
