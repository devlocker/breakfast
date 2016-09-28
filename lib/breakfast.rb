require "breakfast/version"
require "breakfast/live_reload_channel"
require "breakfast/status_channel"
require "breakfast/view_helper"
require "breakfast/brunch_watcher"
require "breakfast/compilation_listener"

module Breakfast
  STATUS_CHANNEL = "breakfast_status".freeze
  RELOAD_CHANNEL = "breakfast_live_reload".freeze
end

require "breakfast/railtie" if defined?(Rails)
