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

### Latest Release `0.5.0`
#### Added
- Adds support for [Yarn](https://yarnpkg.com/).
- New installs now require Yarn
- Capistrano options `:breakfast_yarn_path` && `:breakfast_yarn_install_command`

#### Removed
- NPM client requirement
- Capistrano options `:breakfast_npm_path` && `:breakfast_npm_install_command`
  have been removed.

### Upgrading
#### Upgrading to `0.5.0` from `0.4.0`
- Update gem with `bundle update breakfast`
- Bump the `breakfast-rails` version in `package.json` to `0.5.0`
- Ensure [Yarn](https://yarnpkg.com/docs/install) is installed
- Run `yarn install`

*Note* If you are deploying with Capistrano then Yarn is expected to be
installed on

### Contributing
Bug reports and pull requests are welcome on GitHub at
https://github.com/devlocker/breakfast.

### License
The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
