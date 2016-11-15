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

### Latest Release `0.4.0`
#### Added
- Asset Digests. Now when deploying assets will have fingerprints added to their
  file names. This allows browsers to aggressively cache your assets.
- New Option: `breakfast.manifest.digest`. Defaults to false in development /
  test and true everywhere else. When true, enables Rails to serve fingerprinted
  assets.
- Rake Commands to trigger certain behavior:
  - `breakfast:assets:build`
    Manually run a compilation step.
  - `breakfast:assets:build_production`
    Manually trigger a production build. This will cause assets to get minified.
  - `breakfast:assets:digest`
    Run through your compiled assets and add a fingerprint to each one. Creates
    a copy, leaving a file with the original filename and a duplicate with an
    md5 fingerprint.
  - `breakfast:assets:clean`
    Removes any assets from the output folder that are not specified in the
    manifest file (removes out of date files).
  - `breakfast:assets:nuke`
    Removes manifest and fingerprinted assets from the output folder.
- New Capistrano Option: `:breakfast_npm_install_command`
  Defaults to just `install`. Can be overridden to redirect output to dev/null.
  Example:

  ```
  set :breakfast_npm_install_command, "install > /dev/null 2>&1"
  ```

#### Changes
- Fixed small CSS issue if box-sizing is not set border-box globally.


### Upgrading
#### Upgrading to `0.4.0` from `0.3.0`
- Update gem with `bundle update breakfast`
- Bump the `breakfast-rails` version in `package.json` to `0.4.0`
- Run `npm install`

*Note* Now by default asset fingerprinting will be on by default in production.
A copy of each with the original filename will be present as well, so any
hard-coded links to assets will still work correctly.

### Contributing
Bug reports and pull requests are welcome on GitHub at
https://github.com/devlocker/breakfast.

### License
The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
