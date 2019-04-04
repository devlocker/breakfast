require "rake"
require "breakfast"

namespace :breakfast do
  namespace :assets do
    desc "Prepare assets and digests for production deploy"
    task compile: [:environment] do
      Rake::Task["breakfast:assets:build_production"].execute
      Rake::Task["breakfast:assets:digest"].execute
      Rake::Task["breakfast:assets:clean"].execute
    end

    desc "Build assets for production"
    task build_production: :environment do
      Breakfast.call_system "NODE_ENV=production ./node_modules/brunch/bin/brunch build --production"
    end

    desc "Build assets"
    task build: :environment do
      Breakfast.call_system "./node_modules/brunch/bin/brunch build"
    end

    desc "Add a digest to non-fingerprinted assets"
    task digest: :environment do
      if ::Rails.configuration.breakfast.manifest
        ::Rails.configuration.breakfast.manifest.digest!
      else
        raise Breakfast::ManifestDisabledError
      end
    end

    desc "Remove out of date assets"
    task clean: :environment do
      if ::Rails.configuration.breakfast.manifest
        ::Rails.configuration.breakfast.manifest.clean!
      else
        raise Breakfast::ManifestDisabledError
      end
    end

    desc "Remove manifest and fingerprinted assets"
    task nuke: :environment do
      if ::Rails.configuration.breakfast.manifest
        ::Rails.configuration.breakfast.manifest.nuke!
      else
        raise Breakfast::ManifestDisabledError
      end
    end
  end

  namespace :yarn do
    desc "Install package.json dependencies with Yarn"
    task :install do
      Breakfast.call_system "yarn"
    end
  end
end

if Rake::Task.task_defined?("assets:precompile")
  Rake::Task["assets:precompile"].enhance do
    unless File.exist?("./bin/yarn") && Rake::Task.task_defined?("yarn:install")
      # Rails 5.1 includes a yarn install command - don't yarn install twice.
      Rake::Task["breakfast:yarn:install"].invoke
    end
    Rake::Task["breakfast:assets:compile"].invoke
  end
else
  Rake::Task.define_task(
    "assets:precompile" => ["breakfast:yarn:install", "breakfast:assets:compile"]
  )
end

module Breakfast
  class ManifestDisabledError < StandardError
    def initialize
      super(
        <<~ERROR
          ::Rails.configuration.breakfast.manifest is set to false.
          Enable it by adding the following in your environment file:

            config.breakfast.manifest.digest = true

          *Note* by default digest is set to false in development and test enviornments.

        ERROR
      )
    end
  end

  SystemCallError = Class.new(StandardError)

  def self.call_system(cmd)
    raise SystemCallError, "Failed to execute system command: \"#{cmd}\"" unless system(cmd)
  end
end
