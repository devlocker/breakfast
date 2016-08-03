---
layout: default
---

# Bootstrap

Import the [Bootstrap Framework](http://getbootstrap.com/) into your Rails
project.

## Install Dependencies
In the root of your project directory run:

~~~
npm install --save bootstrap copycat-brunch
~~~

Open up your `brunch_config.js` and make the following modifications.

~~~javascript
npm: {
  styles: {
    // Location of minified css within the bootstrap package
    // To view the contents of any installed package look
    // inside the node_modules folder
    bootstrap: ['dist/css/bootstrap.css']
  },

  globals: {
    $: "jquery",
    "jQuery": "jquery",
    breakfast: "breakfast-rails",

    // Expose bootstrap js globally
    bootstrap: "bootstrap"
  }
}

plugins: {
  copycat: {
    // Copy bootstrap fonts. These will go into the public/assets/fonts folder
    "fonts": ["node_modules/bootstrap/dist/fonts/"]
  }
},
~~~


> [`npm.styles`](http://brunch.io/docs/js-modules-npm.html): Object: a mapping from package name (string) to an array of
> stylesheet paths (relative to package root) to be included into the build.

By using the `npm.styles` option Brunch will automatically place the contents of
the stylesheet into the main `app.css`.
