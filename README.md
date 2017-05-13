<p align="center">
  <img src="http://breakfast.devlocker.io/images/breakfast-illustration.png" width="400" />
</p>

# Breakfast

[Breakfast](http://breakfast.devlocker.io/) integrates modern Javascript
tooling into your Rails project. Powered by [Brunch.io](http://brunch.io).

Get support for ES6 syntax & modules, live reload for CSS, JS, & HTML, and Yarn
support. Be up and running on the latest frontend framework in minutes.


### Installation & Usage
See the official docs at
[http://breakfast.devlocker.io](http://breakfast.devlocker.io).

View updates in the [CHANGELOG](https://github.com/devlocker/breakfast/blob/master/CHANGELOG.md)

### Latest Patch `0.6.2`
#### Fixed
- Typo in install generator. Add brunch-babel package
- Add support for [Wiselinks](https://github.com/igor-alexandrov/wiselinks)
  reloader.
  [_@haffla_](https://github.com/devlocker/breakfast/pull/23)

### Latest Release `0.6.0`
#### Fixed
- Puma hanging in clustered mode. Breakfast would fail to cleanly exit on Puma
  exit, causing the server to hang indefinitely.
- Bumped Rails version dependency, can be used with Rails 5.0 and greater.
  (Allows usage with Rails 5.1)
#### Removed
- Capistrano rake tasks. Previous behavior has been included into the Rails
  asset:precompile task. Using the standard [Capistrano Rails](https://github.com/capistrano/rails)
  gem is all that required now.
- Need for a custom Heroku buildpack.

### Upgrading
#### Upgrading to `0.6.0` from `0.5.x`
- Update gem with `bundle update breakfast`
- Update the JS package with `yarn upgrade breakfast-rails`
- If deploying with Capistrano, remove `require "breakfast/capistrano"` from
  your `Capfile`. Remove any custom Breakfast settings from `config/deploy.rb`.
  Ensure that you are using [Capistrano Rails](https://github.com/capistrano/rails)
  and have `require 'capistrano/rails'` or `require 'capistrano/rails/assets'`
  in your `Capfile`.
- If deploying with Heroku, run the following commands:
  1. heroku buildpacks:clear
  2. heroku buildpacks:set heroku/nodejs --index 1
  3. heroku buildpacks:set heroku/ruby --index 2

*Note* If you are deploying with Capistrano then Yarn is expected to be
installed on the hosts your are deploying to.

### Changes
See list of changes between versions in the CHANGELOG

### Contributing
Bug reports and pull requests are welcome on GitHub at
https://github.com/devlocker/breakfast.

### License
The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
