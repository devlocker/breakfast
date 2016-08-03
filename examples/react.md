---
layout: default
---

# ReactJS

Getting started with [React](https://facebook.github.io/react/).


## Install Dependencies
In the root of your project directory run:

~~~
npm install --save react react-dom babel-preset-react
~~~

Open up your `brunch_config.js` and make the following modifications.

Under the plugins/babel section, add `react` as one of the presets.

~~~javascript
plugins: {
  babel: {
    presets: ['es2015', 'react']
  }
}
~~~~

## Create a Component
Create a components folder - `app/frontend/js/components`. As an example, create
a file in the components folder called `App.jsx` and add the following code in:

~~~javascript
import React from 'react';

export default class App extends React.Component {
  render() {
    return (
      <div id="content">
        <h1>React!</h1>
        <div>
          <a href="https://github.com/devlocker/breakfast">Breakfest Gem</a>
          <a href="https://facebook.github.io/react/index.html">React Docs</a>
        </div>
      </div>
    )
  }
}
~~~

## Import Component
In your view, create a container to hold the component.

~~~html
<div id="app"></div>
~~~

And in `app.js` import the new component and render it.


~~~javascript
import ReactDOM from 'react-dom';
import React from 'react'
import App from './components/App';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(<App />, document.querySelector('#app'));
});
~~~

And that is it!

![react-example]({{ site.baseurl }}/images/examples/react-1.png)

## Usage with Turbolinks
Using React with Turbolinks is a bit more work - but not much. The first thing
to do is to change the event listener from listening to `DOMContentLoaded` to
`turbolinks:load`. Since the page is no longer being fully refreshed, all top
level components need to be unmounted between page changes.

~~~javascript
import ReactDOM from 'react-dom';
import React from 'react';
import App from 'frontend/js/components/App';

var Turbolinks = require('turbolinks');
Turbolinks.start();

document.addEventListener('turbolinks:load', () => {
  ReactDOM.render(<App />, document.querySelector('#app'));
});

document.addEventListener('turbolinks:before-render', () => {
  ReactDOM.unmountComponentAtNode(document.querySelector('#app'));
});
~~~
