---
layout: default
---

# Customizing Asset Location

To change the default asset directory the following changes must be made.

## Modify brunch_config.js

~~~javascript
# joinTo options will need to have their locations modified
files: {
  javascripts: {
    joinTo: {
      'app.js': /^path\/to\/new\/folder\/js\//,
      'vendor.js': /^(path\/to\/new\/folder\/js\/)/,
    }
  },

  ...
  ...
  ...

# The watched path also needs to be updated
paths: {
  watched: [
    "path/to/new/folder"
  ]
}
~~~

## Change Breakfast configuration

~~~ruby
# In config/environments/development.rb
config.breakfast.view_folders = [Rails.root.join("path", "to", "new", "folder")]
~~~
