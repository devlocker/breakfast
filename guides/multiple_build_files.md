---
layout: default
---

# Multiple Build Files
If having just one build file (`app.js`) is too limiting, it is possible to
create multiple build files or bundles.

For this example, imagine there is a web application with a user facing area and
an admin area. For the sake of the example, we want the admin code to be
separate from the client side.

The folder structure we want looks like this

~~~
- app/
  - frontend/
    - admin/
      - css/
      - js/
      - images/
    - client/
      - css/
      - js/
      - images
~~~

To split up the build targets modify the `brunch_config` like so:

~~~javascript
  files: {
    javascripts: {
      joinTo: {
        'admin.js': /^app\/frontend\/admin\/js\//,
        'client.js': /^app\/frontend\/client\/js\//,
        'vendor.js': /^(?!app\/frontend\/js)/
      }
    },
    stylesheets: {
      joinTo: {
        'admin.css': /^app\/frontend\/admin\/css\//,
        'client.css': /^app\/frontend\/client\/css\//,
        'vendor.css': /^(?!app\/frontend\/)/
      }
    }
  },
~~~

Now in each layout just require the relevant files:

~~~erb
# app/views/layouts/admin.html.erb
<%= stylesheet_link_tag "vendor.css" %>
<%= stylesheet_link_tag "admin.css" %>

<%= javascript_include_tag "vendor.js" %>
<%= javascript_include_tag "admin.js" %>

# app/views/layouts/application.html.erb
<%= stylesheet_link_tag "vendor.css" %>
<%= stylesheet_link_tag "client.css" %>

<%= javascript_include_tag "vendor.js" %>
<%= javascript_include_tag "client.js" %>
~~~

> Need even more fine grained detail? [Read the official
> docs](https://github.com/brunch/brunch-guide/blob/master/content/en/chapter04-starting-from-scratch.md#split-targets).
