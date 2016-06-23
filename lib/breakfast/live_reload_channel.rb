require "rails"

module Breakfast
  class LiveReloadChannel < ::ActionCable::Channel::Base
    def subscribed
      stream_from "breakfast_live_reload"
    end
  end
end
