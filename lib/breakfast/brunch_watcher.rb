require "pty"

module Breakfast
  class BrunchWatcher
    BRUNCH_COMMAND = "./node_modules/brunch/bin/brunch watch".freeze

    def self.spawn(log:)
      new(log: log).run
    end

    attr_reader :log
    def initialize(log:)
      @log = log
    end

    def run
      out, writer, pid = PTY.spawn(BRUNCH_COMMAND)
      writer.close

      Process.detach(pid)

      begin
        loop do
          output = out.readpartial(64.kilobytes).strip
          log.debug output

          output = output.gsub(/\e\[([;\d]+)?m/, '')
          case output
          when /compiled/
            broadcast(status: "success", message: output.split("info: ").last)
          when /error/
            broadcast(status: "error", message: output.split("error: ").last)
          end
        end
      rescue EOFError, Errno::EIO
        log.fatal "[BREAKFAST] Watcher died unexpectedly. Restart Rails Server"
        broadcast(
          status: "error",
          message: "Watcher died unexpectedly. Restart Rails server"
        )
      end
    end

    private

    def broadcast(status:, message:)
      ActionCable.server.broadcast(STATUS_CHANNEL, {
        status: status,
        message: message
      })
    end
  end
end
