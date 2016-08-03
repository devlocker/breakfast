---
layout: default
---

# Configuration
Breakfast has several configuration options available. Modify them in
`config/environments/development.rb`. Below are all of the options and their
defaults.

~~~ruby
# Reload strategy to use when an HTML Template changes.
# Default: :turbolinks
# Options:
#   - :turbolinks
#     Will revisit the current page using turbolinks. 
#     This is much quicker than doing a full page reload.
#
#   - :page
#     Does a refresh of the page.
#
#   - :off
#     Do nothing
#
config.breakfast.html_reload_strategy = :turbolinks


# Reload strategy to use when a JS file changes.
# Default: :page
# Options:
#   - :page
#     Does a refresh of the page.
#
#   - :off
#     Do nothing
#
# Coming soon - :hot_reload - Add / Remove / Change JS 
# modules without needing a page reload 
#
config.breakfast.js_reload_strategy = :page


# Reload strategy to use when a CSS file changes.
# Default: :hot
# Options:
#   - :hot
#     Re-injects the new CSS without a page refresh.
#
#   - :page
#     Does a refresh of the page.
#
#   - :off
#     Do nothing
#
config.breakfast.css_reload_strategy = :hot


# Where compiled assets get outputted. Should match 
# the public option in brunch_config.js
config.breakfast.asset_output_folders = [Rails.root.join("public")]


# Where your views are located. Breakfast looks 
# in these folders to know when an html file has changed.
config.breakfast.view_folders = [Rails.root.join("app", "views")]


# Environments to run Breakfast in.
config.breakfast.environments = %w(development)
~~~
