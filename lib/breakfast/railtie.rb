require "rails"
require "listen"

module BrunchRails
  class Railtie < ::Rails::Railtie
    config.breakfast = ActiveSupport::OrderedOptions.new

    config.before_configuration do |app|
      config.breakfast.html_reload_strategy = :turbolinks
      config.breakfast.js_reload_strategy = :page
      config.breakfast.css_reload_strategy = :hot

      config.breakfast.asset_output_folders = [Rails.root.join("public")]
      config.breakfast.view_folders = [Rails.root.join("app", "views")]
      config.breakfast.environments = %w(development)
    end

    initializer "breakfast.setup_view_helpers" do |app|
      ActiveSupport.on_load(:action_view) do
        include ::Breakfast::ViewHelper
      end
    end

    config.after_initialize do |app|
      if config.breakfast.environments.include?(Rails.env) && defined?(Rails::Server)
        @brunch_pid = Process.spawn("brunch watch")
        Process.detach(@brunch_pid)

        listen_to_paths = Array.wrap(config.breakfast.asset_output_folders) +
          Array.wrap(config.breakfast.view_folders)

        listener = ::Listen.to(*listen_to_paths) do |modified, added, removed|
          files = modified + added + removed
          extensions = ["css", "js", "html"].freeze

          extensions.each do |extension|
            if files.any? { |file| file.match(/\.#{extension}/) }
              ActionCable.server.broadcast "breakfast_live_reload", { extension: extension }
            end
          end
        end

        listener.start
      end
    end

    ActionView::Helpers::AssetUrlHelper::ASSET_PUBLIC_DIRECTORIES[:javascript] = "/assets"
    ActionView::Helpers::AssetUrlHelper::ASSET_PUBLIC_DIRECTORIES[:image] = "/assets"
    ActionView::Helpers::AssetUrlHelper::ASSET_PUBLIC_DIRECTORIES[:stylesheet] = "/assets"
  end
end
