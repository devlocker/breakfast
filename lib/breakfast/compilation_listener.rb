module Breakfast
  class CompilationListener
    EXTENSIONS = ["css", "js", "html"].freeze
    CHANNEL = "breakfast_live_reload".freeze

    def self.start(asset_output_folders:, view_folders:)
      listen_to_paths = Array.wrap(asset_output_folders) + Array.wrap(view_folders)

      listener = ::Listen.to(*listen_to_paths) do |modified, added, removed|
        files = modified + added + removed

        EXTENSIONS.each do |extension|
          if files.any? { |file| file.match(/\.#{extension}/) }
            ActionCable.server.broadcast(CHANNEL, { extension: extension })
          end
        end
      end

      listener.start
    end
  end
end
