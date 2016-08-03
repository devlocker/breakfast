# What gets installed

## app/frontend folder
Inside of it you will find a folder for `js`, `css` and `images`. It should
resemble what the Asset Pipeline gives you in a standard Rails application.
While the location of your assets is ultimately flexible, this is the
recommended default location to place your application's frontend code.

## package.json
Contains a list of Javascript dependencies to fetch and install from `npm`. You
can think of this as the Javascript equivalent to the `Gemfile`. It is also used
to store certain metadata about the current project or module, but that part
will be of little use to us.

_Read more about [package.json
here](https://docs.npmjs.com/files/package.json)._

## brunch-config.js
This configuration file for `brunch`. This comes preconfigured to just work™.
Once you start your Rails server Breakfast will have brunch compile your assets
into the `public/assets` folder. The `files` option tells Brunch where to look
for assets and how to combine them.

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
`vendor.js`. Brunch automatically knows that `vendor.js` should not have [module
wrapping applied](https://github.com/brunch/brunch-guide/blob/master/content/en/chapter03-conventions-and-defaults.md#commonjs-module-wrapping) to it. For CSS we don't need to worry about splitting our code from vendored code so we just join everything in the project into `app.css`.

## node_modules
When `npm` installs packages and dependencies specified in the `package.json`
they are placed in the `node_modules` folder. The install step automatically
added that folder to your `.gitignore`. The folder should not be committed to your repository.
