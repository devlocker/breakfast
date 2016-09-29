namespace :breakfast do
  desc "Compile assets for production use"
  task :compile do
    on roles fetch(:breakfast_roles) do |host|
      within release_path do
        execute fetch(:breakfast_npm_path).to_sym, "install"
        execute "node_modules/brunch/bin/brunch", "build --production"
      end
    end
  end

 after "deploy:updated", "breakfast:compile"
end


namespace :load do
  task :defaults do
    set :breakfast_roles, -> { :web }
    set :breakfast_npm_path, "/usr/bin/npm"
  end
end
