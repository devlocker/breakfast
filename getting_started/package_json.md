---
layout: default
---

# package.json
Contains a list of Javascript dependencies to fetch and install from `npm`. You
can think of this as the Javascript equivalent to the `Gemfile`. It is also used
to store certain metadata about the current project or module, but that part
will be of little use to us.

_Read more about [package.json here](https://docs.npmjs.com/files/package.json)._


## Default Dependencies
Breakfast includes some Rails packages to mirror what Sprockets will do for you
on a new app. ActionCable, Turbolinks and jquery-ujs are included by default.
These can all be removed if you have no intention of using them - they are just
provided as reasonable defaults.

breakfast-rails is also included. It can be removed if you would like to remove
the auto-reloading features.
