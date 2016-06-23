require "breakfast/version"
require "breakfast/live_reload_channel"
require "breakfast/view_helper"

module Breakfast
end

require "breakfast/railtie" if defined?(Rails)
