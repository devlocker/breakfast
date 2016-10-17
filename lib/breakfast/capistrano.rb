require "capistrano/version"

if defined?(Capistrano::VERSION) && Gem::Version.new(Capistrano::VERSION).release >= Gem::Version.new("3.0.0")
  load File.expand_path("../capistrano/tasks/breakfast.rake", __FILE__)
else
  raise "Requires Capistrano V3"
end

