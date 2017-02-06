require "rails"
require "fileutils"
require "listen"

module Breakfast
  class Railtie < ::Rails::Railtie
    config.breakfast = ActiveSupport::OrderedOptions.new

    config.before_configuration do |app|
      config.breakfast.html_reload_strategy = :turbolinks
      config.breakfast.js_reload_strategy = :page
      config.breakfast.css_reload_strategy = :hot
      config.breakfast.ruby_reload_strategy = :off

      config.breakfast.asset_output_folder = Rails.root.join("public", "assets")
      config.breakfast.source_code_folders = [Rails.root.join("app")]
      config.breakfast.environments = %w(development)
      config.breakfast.status_bar_location = :bottom
      config.breakfast.digest = !(Rails.env.development? || Rails.env.test?)
    end

    initializer "breakfast.setup_view_helpers" do |app|
      ActiveSupport.on_load(:action_view) do
        include ::Breakfast::ViewHelper
      end
    end

    rake_tasks do
      load "tasks/breakfast.rake"
    end

    config.after_initialize do |app|
      if config.breakfast.digest
        config.breakfast.manifest = Breakfast::Manifest.new(base_dir: config.breakfast.asset_output_folder)
      end

      if config.breakfast.environments.include?(Rails.env) && LocalEnvironment.new.running_server?
        # Ensure public/assets directory exists
        FileUtils.mkdir_p(Rails.root.join('public', 'assets'))

        Thread.new do
          Breakfast::BrunchWatcher.spawn(log: Rails.logger)
        end

        Breakfast::CompilationListener.start(
          asset_output_folder: config.breakfast.asset_output_folder,
          source_code_folders: config.breakfast.source_code_folders
        )
      end
    end

    ActionView::Helpers::AssetUrlHelper::ASSET_PUBLIC_DIRECTORIES[:javascript] = "/assets"
    ActionView::Helpers::AssetUrlHelper::ASSET_PUBLIC_DIRECTORIES[:image] = "/assets"
    ActionView::Helpers::AssetUrlHelper::ASSET_PUBLIC_DIRECTORIES[:stylesheet] = "/assets"
  end

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
      defined?(Rails::Server)
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
