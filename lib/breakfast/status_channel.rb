require "rails"

module Breakfast
  class StatusChannel < ::ActionCable::Channel::Base
    def subscribed
      stream_from "breakfast_status"
    end
  end
end
