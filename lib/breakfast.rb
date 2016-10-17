require "breakfast/version"

require "breakfast/brunch_watcher"
require "breakfast/compilation_listener"
require "breakfast/live_reload_channel"
require "breakfast/manifest"
require "breakfast/status_channel"
require "breakfast/view_helper"

module Breakfast
  STATUS_CHANNEL = "breakfast_status".freeze
  RELOAD_CHANNEL = "breakfast_live_reload".freeze
  BUILD_COMMAND = "./node_modules/brunch/bin/brunch build".freeze
  PRODUCTION_BUILD_COMMAND = "./node_modules/brunch/bin/brunch build --production".freeze
end

require "breakfast/railtie" if defined?(Rails)
