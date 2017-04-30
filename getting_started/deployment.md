---
layout: default
---

# Deployment

## Heroku
Deploying to Heroku is super simple. Just add the NodeJS buildpack

~~~
heroku buildpacks:clear
heroku buildpacks:set heroku/nodejs --index 1
heroku buildpacks:set heroku/ruby --index 2
~~~

## Heroku for older versions of Breakfast (0.5.x and earlier)
Add the custom buildpack

~~~
heroku buildpacks:add --index 2 https://github.com/devlocker/heroku-buildpack-breakfast.git
~~~

## Capistrano V3 

Breakfast plugs into the `assets:precompile` task. So as long as you have
[Capistrano Rails](https://github.com/capistrano/rails) and `node`  installed
there is nothing else you need to do.

## Capistrano for older versions of Breakfast (0.5.x and earlier)
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
