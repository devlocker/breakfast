require "spec_helper"
require "tmpdir"

RSpec.describe "Installing the Gem" do
  describe "Using generator" do
    specify do
      rails_dir = Dir.mktmpdir

      %x{rails new #{rails_dir}}
      open("#{rails_dir}/Gemfile", "a") { |file| file.write('gem "breakfast"') }

      %x{cd #{rails_dir} && bundle install}
      %x{cd #{rails_dir} && rails generate breakfast:install}
      %x{cd #{rails_dir} && node_modules/brunch/bin/brunch build}

      expect(File).to exist("#{rails_dir}/brunch-config.js")
      expect(File).to exist("#{rails_dir}/package.json")
      expect(File).to exist("#{rails_dir}/app/frontend/js/app.js")
      expect(File).to exist("#{rails_dir}/app/frontend/css/app.scss")
      expect(File.directory?("#{rails_dir}/node_modules")).to be true
      expect(File).to exist("#{rails_dir}/public/assets/app.css")
      expect(File).to exist("#{rails_dir}/public/assets/app.js")
    end
  end
end
