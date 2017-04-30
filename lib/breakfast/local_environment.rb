module Breakfast
  class LocalEnvironment
    def running_server?
      possible_servers = %w[
        rails
        puma
        passenger
        unicorn
        mongrel
        webrick
        rainbows
      ]

      possible_servers.any? do |server|
        send "detect_#{server}"
      end
    end

    private

    def detect_rails
      defined?(::Rails::Server)
    end

    def detect_puma
      defined?(::Puma) && File.basename($0) == "puma"
    end

    def detect_passenger
      defined?(::PhusionPassenger)
    end

    def detect_thin
      defined?(::Thin) && defined?(::Thin::Server)
    end

    def detect_unicorn
      defined?(::Unicorn) && defined?(::Unicorn::HttpServer)
    end

    def detect_mongrel
      defined?(::Mongrel) && defined?(::Mongrel::HttpServer)
    end

    def detect_webrick
      defined?(::WEBrick) && defined?(::WEBrick::VERSION)
    end

    def detect_rainbows
      defined?(::Rainbows) && defined?(::Rainbows::HttpServer)
    end
  end
end
