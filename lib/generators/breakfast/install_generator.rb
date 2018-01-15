require "rails/generators"

module Breakfast
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      NODE_VERSION = Gem::Version.new("4.1.0")

      def install
        if node_prerequisites_installed?
          create_brunch_config
          create_package_json if using_rails_5_dot_0?
          install_required_packages
          create_directory_structure
          create_app_js_file
          create_app_scss_file
          create_gitkeep_files
          add_node_modules_to_gitignore

          puts <<-SUCCESS.strip_heredoc

            ---> BREAKFAST INSTALLED SUCCESSFULLY
            ---> See https://github.com/devlocker/breakfast for documentation and examples.

          SUCCESS
        else
          puts <<-ERROR.strip_heredoc

            ---> ERROR - MISSING NODE & YARN

            ---> Node version >= #{NODE_VERSION} & yarn are required to run Breakfast.
            ---> Please install them before attempting to continue.
            ---> https://nodejs.org
            ---> https://yarnpkg.com/docs/install/

          ERROR
        end
      end

      private

      def node_prerequisites_installed?
        `which node`.present? && `which yarn`.present? && node_versions_are_satisfactory?
      end

      def node_versions_are_satisfactory?
        installed_node_version >= NODE_VERSION
      end

      def installed_node_version
        Gem::Version.new(`node -v`.tr("v", ""))
      end

      def create_brunch_config
        copy_file "brunch-config.js", "brunch-config.js"
      end

      def create_package_json
        copy_file "package.json", "package.json"
      end

      def install_required_packages
        packages = %w(
          actioncable
          babel
          babel-brunch
          breakfast-rails
          brunch
          clean-css-brunch
          jquery
          jquery-ujs
          sass-brunch
          turbolinks
          uglify-js-brunch
        )
        run "yarn add #{packages.join(' ')}"
      end

      def create_directory_structure
        empty_directory "app/frontend/css"
        empty_directory "app/frontend/images"
        empty_directory "app/frontend/js"
        empty_directory "app/frontend/vendor"
      end

      def create_app_js_file
        copy_file "app.js", "app/frontend/js/app.js"
      end

      def create_app_scss_file
        copy_file "app.scss", "app/frontend/css/app.scss"
      end

      def create_gitkeep_files
        create_file "app/frontend/images/.gitkeep"
        create_file "app/frontend/vendor/.gitkeep"
      end

      def add_node_modules_to_gitignore
        ignore = <<-IGNORE.strip_heredoc
          # Added by Breakfast Gem
          yarn-error.log
          npm-debug.log
          node_modules/*
          public/assets/*
        IGNORE

        append_to_file(".gitignore", ignore)
      end

      def using_rails_5_dot_0?
        Gem::Version.new(::Rails.version) < Gem::Version.new("5.1")
      end
    end
  end
end
