require "breakfast/version"

require "breakfast/brunch_watcher"
require "breakfast/compilation_listener"
require "breakfast/live_reload_channel"
require "breakfast/manifest"
require "breakfast/rails/helper"
require "breakfast/rails/local_environment"
require "breakfast/status_channel"

module Breakfast
  STATUS_CHANNEL = "breakfast_status".freeze
  RELOAD_CHANNEL = "breakfast_live_reload".freeze
end

require "breakfast/rails/railtie" if defined?(::Rails)
