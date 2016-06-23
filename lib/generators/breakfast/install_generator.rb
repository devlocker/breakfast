require "rails/generators"

module Breakfast
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def install
        if prerequisites_installed?
          create_brunch_config
          create_package_json
          create_directory_structure
          create_app_js_file
          create_app_scss_file
          create_gitkeep_files
          run_npm_install
          add_node_modules_to_gitignore

          puts <<-SUCCESS.strip_heredoc

            ---> BREAKFAST INSTALLED SUCCESSFULLY
            ---> See https://github.com/devlocker/breakfast for documentation and examples.

          SUCCESS
        else
          puts <<-ERROR.strip_heredoc

            ---> ERROR - MISSING NODE & NPM

            ---> Node & npm are required to run Breakfast.
            ---> Please install them before attempting to continue.
            ---> https://nodejs.org
            ---> https://npmjs.org

          ERROR
        end
      end

      private

      def prerequisites_installed?
        `which node`.present? && `which npm`.present?
      end

      def create_brunch_config
        copy_file "brunch-config.js", "brunch-config.js"
      end

      def create_package_json
        copy_file "package.json", "package.json"
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

      def run_npm_install
        run "npm install"
      end

      def add_node_modules_to_gitignore
        ignore = <<-IGNORE.strip_heredoc
          # Added by Breakfast Gem
          npm-debug.log
          node_modules/*
          public/assets/*
        IGNORE

        append_to_file(".gitignore", ignore)
      end
    end
  end
end
