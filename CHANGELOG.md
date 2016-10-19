# CHANGE LOG

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
