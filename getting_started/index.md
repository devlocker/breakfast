---
layout: default
---

# Getting Started
Breakfast integrates modern Javascript tooling into your Rails project.

Get support for ES6 syntax & modules, live reload for CSS, JS, & HTML, and Yarn
support. Be up and running on the latest frontend framework in minutes.

As you save your assets they will get compiled on the fly into bundles. Updates
get pushed down to the browser and depending on the configured reload strategy
will hot swap the code or reload the page automatically.


## Powered by Brunch
You can think of `Breakfast` as the glue between the excellent [Brunch build
tool](http://brunch.io/) and Rails. 

> Brunch is fundamentally specialized and geared towards building assets, these
files that get used in the end by your runtime platform, usually a web browser.
It thus comes pre-equipped with a number of behaviors and features. You’ll most
notably get:

> - Categorization of source files: JavaScript, Style sheets, Templates and
“miscellanea”;
> - Smart concatenation of these files towards one or more target files;
> - Module wrapping of JavaScript files;
> - Handling of front-end dependencies with Yarn;
> - Maintenance of all relevant source maps;
> - Minification of resulting files if we’re in “production mode”;
> - Watching of source files to update the build on the fly.

## Dependencies

`Breakfast` at the moment only supports Rails 5.0+. You will also need `Node.js`
and `Yarn` installed.


## Installation

Add `breakfast` to the `Gemfile`.

~~~ruby
gem "breakfast"
~~~

Run `bundle install`.

To setup `Breakfast` run the generator that ships with the gem.

~~~
rails generate breakfast:install
~~~

~~~
# Sample Output 
$ rails generate breakfast:install
	create  brunch-config.js
	create  package.json
	create  app/frontend/css
	create  app/frontend/images
	create  app/frontend/js
	create  app/frontend/vendor
	create  app/frontend/js/app.js
	create  app/frontend/css/app.scss
	create  app/frontend/images/.gitkeep
	create  app/frontend/vendor/.gitkeep
		 run  yarn install from "."
~~~

Read the linked pages for more information on some of the generated files.

* [package.json]({{ '/getting_started/package_json' | prepend: site.baseurl }})
* [brunch_config.js]({{ '/getting_started/brunch_config' | prepend: site.baseurl }})

## Conventions
Breakfast out of the box expects the assets in the project to live in the
`app/frontend/` folder. See the guide for [Customizing Asset Location]({{ '/guides/customizing_asset_location.html' | prepend: site.baseurl }})
if this does not suit your preference.

## Usage

Start a Rails server. Almost immediately there should be information in the logs
about asset compilation.

~~~
info: compiled 6 files into 3 files in 808ms
~~~

This first build is combining the JS and CSS into files specified in the
`brunch-config`. By default these will be `app.js`, `vendor.js` and `app.css`.

To get them loaded onto the page use the `javascript_include_tag`,
`stylesheet_link_tag` and `image_tag` just like you normally would.

~~~erb
# In application.html.erb

<head>
  <%= stylesheet_link_tag "app.css" %>
  <%= javascript_include_tag "vendor.js" %>
  <%= javascript_include_tag "app.js" %>
  <script>require('frontend/js/app').init();</script>
  <%= breakfast_autoreload_tag %>
</head>
~~~
The `breakfast_autoreload_tag` setups auto reloading only in development mode.

## Understanding Modules

Take a look at the auto generated file `app/frontend/js/app.js`

~~~javascript
const App = {
  init() {
  }
};

module.exports = App;
~~~

Brunch [wraps your code in modules](https://github.com/brunch/brunch-guide/blob/master/content/en/chapter03-conventions-and-defaults.md#commonjs-module-wrapping),
which means that any code that is written is not automatically executed or put
into the global state.

The `require('frontend/js/app').init()` line from above requires the
module located at that file path and executes the `init` function on the
returned module.

To see how modules work create another a file `app/js/frontend/hello.js`.

~~~javascript
const HelloWorld = {
  sayHello() {
    console.log("Hello World");
  }
}

module.exports = HelloWorld;
~~~

Modify `app.js` to import this module and use it.

~~~javascript
// Relative Path
import HelloWorld from "./hello"

// Alternative: Full path
// import HelloWorld from "frontend/js/hello"

const App = {
  init() {
    HelloWorld.sayHello();
  }
};

module.exports = App;
~~~

_Note: There are many ways [to use
imports](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import)
and
[exports](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/export)._


## Automatic Processing

On modification of HTML, JS or CSS files output like this should appear in the
Rails console.

~~~
info: compiled app.scss into app.css in 89ms
~~~

Because Brunch is an incremental build system it only rebuilds the bits that
change. The first build on server start up was slower because it had to compile
everything. As you make changes you'll find that Brunch does an amazing job at
rebuilding particular files in just a few tenths of a second.

Breakfast takes care of running Brunch for you while the Rails server is
running. Should you want to run the Brunch build step on your own run:

~~~
bin/rails breakfast:assets:build
~~~

If you have installed Brunch globally with `yarn global add brunch` then you
can also run:

~~~
brunch build
~~~

## Adding Javascript libraries
Adding Javascript libraries in Rails involves either adding a Gem or downloading
a file to `vendor/assets/javascripts`. To add the library into the application
you would use Sprockets `require` in a manifest file.

With Breakfast you can add frontend libraries using
[NPM](https://www.npmjs.com/).

For example, to add the [Pikaday](https://www.npmjs.com/package/pikaday)
calender picker run:

~~~
yarn add pikaday
~~~

This will add the latest version to the `package.json` and install the code into
the `node_modules` directory. To use the library, return to
`app/frontend/js/app.js` require it.


~~~javascript
import Pikaday from "pikaday";

let App = {
  init() {
    let picker = new Pikaday({ field: $('#datepicker')[0] });
  }
};

module.exports = App;
~~~
