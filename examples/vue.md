---
layout: default
---

# Vue.js

Getting started with [Vue](https://vuejs.org/).

This will show you how to setup Vue and use the recommended [Single File
Components](https://vuejs.org/v2/guide/single-file-components.html).

## Install Dependencies
In the root of your project directory run:

~~~
npm install --save vue
npm install --save-dev vue-brunch vueify postcss-brunch babel-plugin-transform-runtime
~~~

## Expose Vue Globally

In `brunch-config.js` add this to the `npm` section:

~~~
npm: {
  globals: {
    Vue: 'vue/dist/vue.common.js'
  }
}
~~~

This imports the [Standalone
Version](https://vuejs.org/v2/guide/installation.html#Standalone-vs-Runtime-only-Build)
as opposed to the runtime only. We need the standalone version to get the
compiler and `template` options.

## Ensure Templates Option is present in brunch-config
In `brunch-config.js` ensure the `templates` option in `files` is set to this:

~~~javascript
files: {
  javascripts: {
   'app.js': /^app\/frontend\/js\//,
   'vendor.js': /^(?!app\/frontend\/js)/
  }
  ...
  // Make sure templates is there. New installs of Breakfast
  // should have this by default.
  templates: {
    joinTo: 'app.js'
  }
}
~~~

## Create a Component
Create a components folder - `app/frontend/js/components`. As an example, create
a file in the components folder called `Hello.vue` and add the following code in:

~~~javascript
<template>
  <div>
    {% raw %}<h1>{{ message }}</h1>{% endraw %}
  </div>
</template>

<script>
  export default {
    data() {
      return {
        message: "Hello from Vue!"
      }
    }
  }
</script>
~~~

## Require the Component
Assuming in your layout there is a div with an id of `root`, in
`app/frontend/js/app.js` add the following:

~~~javascript
import Hello from './components/Hello';

// Import this if you wish to use CSS in your .vue files.
// See section below for more information.
import "vueify/lib/insert-css";

let App = {
  init() {
    $(document).on("turbolinks:load", () => {
      new Vue({
        el: '#root',
        components: {
          'hello': Hello
        }
      })
    });
  }
}
~~~

## Render Components

In your view render your components:

~~~html
<div id="root">
  <hello></hello>
</div>
~~~

## CSS in .vue files

[Vue single file
components](https://vuejs.org/v2/guide/single-file-components.html) also support
adding CSS. Here are some examples of how to use CSS (or SCSS, Stylus, etc.).

~~~html
// Add a style tag anywhere in the .vue file.

<style>
  h1 {
    color: #000;
  }
</style>



// To use SCSS, add the lang option.
// Imports and other SCSS features work as you would expect.

<style lang="scss">
  @import "../../css/variables"

  .header {
    h1 {
      color: $headings-color;
    }
  }
</style>



// PostCSS also supports a scoped option.
// This will scope the CSS within the component.

<style scoped>
  // Without the scoped option, all H1 elements on
  // the page would be affected.   By using scoped
  // only H1's in this component will be styled.
  h1 {
    color: #000;
  }
</style>
~~~


## With Turbolinks
If you are using Turbolinks then we have to tear down the root component before
rendering a new page.

Modify `app.js` to look like this:

~~~javascript
let App = {
  init() {
    let root;

    $(document).on("turbolinks:load", () => {
      root = new Vue({
        el: '#root',
        components: {
          'hello': Hello
        }
      })
    });

    $(document).on("turbolinks:before-render", () => {
      root.$destroy();
    });
  }
}
~~~
