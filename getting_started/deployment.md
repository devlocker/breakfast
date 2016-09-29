---
layout: default
---

# Deployment

## Heroku
Deploying to Heroku to requires two changes.

Node.js Buildpack - Needed to download packages from NPM and build your minified
files. Install with:

~~~
heroku buildpacks:add --index 1 heroku/nodejs
~~~

Postbuild Step - In `package.json` add a postbuild step to build your assets.

~~~javascript
// Inside package.json
scripts: {
  "heroku-postbuild": "brunch build --production"
}
~~~

## Capistrano V3 

Breakfast ships with deploy tasks for Capistrano V3.

In your `Capfile`

~~~
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
~~~

The servers that run asset compilation will need to have `node` installed.

