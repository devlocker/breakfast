# CHANGE LOG

### 0.4.0 - 2016-11-14
#### Upgrading to `0.4.0` from `0.3.0`
- Update gem with `bundle update breakfast`
- Bump the `breakfast-rails` version in `package.json` to `0.4.0`
- Run `npm install`

*Note* Now by default asset fingerprinting will be on by default in production.
A copy of each with the original filename will be present as well, so any
hard-coded links to assets will still work correctly.

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


#### Contributors
Many many thanks to the contributors for this release!
- [@patkoperwas](https://github.com/patkoperwas)
- [@mikeastock](https://github.com/mikeastock)
- [@HParker](https://github.com/HParker)


## 0.3.1 - 2016-10-19
- Better support for determining if Server is running. Using puma, passneger,
  etc. instead of the default rails server command now work.


## 0.3.0 - 2016-09-28

### Upgrading from `0.2.0`
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

### Added
- New status bar that allows the user to switch reload strategies on the fly
- Support for Haml & Slim files (without .html extension)
- Reloading on ruby file changes.
- Specify minimum Node & NPM versions when installing (avoid awkward and none
  descriptive error messages)
- NPM binary path for Capistrano

### Changes
- config.breakfast.view_folders change to config.breakfast.source_code_folders.
  Change brought about by need to trigger reloads when Ruby source code changes.

### Removed
- config.breakfast.view_folders is no longer supported. Deprecated in favor of
  source_code_folders option.

#### Contributors
Many many thanks to the contributors for this release!

- [@patkoperwas](https://github.com/patkoperwas)
- [@josh-rosen](https://github.com/Josh-Rosen)
