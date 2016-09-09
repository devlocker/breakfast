require "rails"

module Breakfast
  class StatusChannel < ::ActionCable::Channel::Base
    def subscribed
      logger.info "Subscribed to channel"
      stream_from "breakfast_status"
    end
  end
end
