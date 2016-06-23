namespace :breakfast do
  desc "Compile assets for production use"
  task :compile do
    on roles fetch(:breakfast_roles) do |host|
      within release_path do
        execute :npm, "install"
        execute "node_modules/brunch/bin/brunch", "build --production"
      end
    end
  end

 after "deploy:updated", "breakfast:compile"
end


namespace :load do
  task :defaults do
    set :breakfast_roles, -> { :web }
  end
end
