<p align="center">
  <img src="http://breakfast.devlocker.io/images/breakfast-illustration.png" width="400" />
</p>
# Breakfast
[Breakfast](http://breakfast.devlocker.io/) integrates modern Javascript
tooling into your Rails project. Powered by [Brunch.io](http://brunch.io). 

Get support for ES6 syntax & modules, live reload for CSS, JS, & HTML, and NPM
support. Be up and running on the latest frontend framework in minutes.


### Installation & Usage
See the official docs at
[http://breakfast.devlocker.io](http://breakfast.devlocker.io).

View updates in the [CHANGELOG](https://github.com/devlocker/breakfast/blob/master/CHANGELOG.md)

### Latest Release `0.3.0`
#### Added
- New status bar that allows the user to switch reload strategies on the fly
- Support for Haml & Slim files (without .html extension)
- Reloading on ruby file changes.
- Specify minimum Node & NPM versions when installing (avoid awkward and none
  descriptive error messages)
- NPM binary path for Capistrano

#### Changes
- config.breakfast.view_folders change to config.breakfast.source_code_folders.
  Change brought about by need to trigger reloads when Ruby source code changes.

#### Removed
- config.breakfast.view_folders is no longer supported. Deprecated in favor of
  source_code_folders option.


### Upgrading
#### Upgrading to `0.3.0` from `0.2.0`
- Update gem with `bundle update breakfast`
- Bump the `breakfast-rails` version in `package.json` to `0.3.1`
- Run `npm install`
- If you have modified the `config.breakfast.view_folders` option you will need
  to replace it. The new option is `config.breakfast.source_code_folders` and it
  defaults to `[Rails.root.join("app")]`. If you have view or Ruby files that
  you would like to trigger reloads outside of the `app` folder then append
  those paths by adding:

  ```
  config.breakfast.source_code_folders << Rails.root.join("lib")
  ```

  To which ever environment you want `Breakfast` to run in
  (probably `config/environments/development.rb`).


### Contributing
Bug reports and pull requests are welcome on GitHub at
https://github.com/devlocker/breakfast.

### License
The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
