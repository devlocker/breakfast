---
layout: default
---

# Deployment

## Heroku
Deploying to Heroku is super simple. Just add the custom buildpack.

~~~
heroku buildpacks:add --index 1 https://github.com/devlocker/heroku-buildpack-breakfast.git
~~~



## Capistrano V3 

Breakfast ships with deploy tasks for Capistrano V3.

In your `Capfile`

~~~ruby
require "breakfast/capistrano"
~~~

If you want roles besides `web` to run asset compilation modify the
`breakfast_roles` option in `config/deploy.rb`

Breakfast needs to run `npm` while deploying. If the npm installation is at a
location different than `/usr/bin/npm` you will need to modify the
`breakfast_npm_path` option.

~~~ruby
set :breakfast_roles, -> { :web, :app }
set :breakfast_npm_path, "/usr/bin/npm"
set :breakfast_npm_install_command, "install"
~~~

The servers that run asset compilation will need to have `node` installed.
