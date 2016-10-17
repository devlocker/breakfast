require "rake"
require "breakfast"

namespace :breakfast do
  namespace :assets do
    desc "Build assets"
    task :build => :environment do
      exec(Breakfast::BUILD_COMMAND)
    end

    desc "Build assets for production"
    task :build_production => :environment do
      exec(Breakfast::PRODUCTION_BUILD_COMMAND)
    end

    desc "Add a digest to non-fingerprinted assets"
    task :digest => :environment do
      if Rails.configuration.breakfast.manifest
        Rails.configuration.breakfast.manifest.digest!
      else
        raise Breakfast::ManifestDisabledError
      end
    end

    desc "Remove out of date assets"
    task :clean => :environment do
      if Rails.configuration.breakfast.manifest
        Rails.configuration.breakfast.manifest.clean!
      else
        raise Breakfast::ManifestDisabledError
      end
    end

    desc "Remove manifest and fingerprinted assets"
    task :nuke => :environment do
      if Rails.configuration.breakfast.manifest
        Rails.configuration.breakfast.manifest.nuke!
      else
        raise Breakfast::ManifestDisabledError
      end
    end
  end
end

module Breakfast
  class ManifestDisabledError < StandardError
    def initialize
      super(
        <<~ERROR
          Rails.configuration.breakfast.manifest is set to false. 
          Enable it by adding the following in your environment file:

            config.breakfast.manifest.digest = true

          *Note* by default digest is set to false in development and test enviornments.

        ERROR
      )
    end
  end
end
