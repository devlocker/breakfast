namespace :breakfast do
  desc "Compile assets for production use"
  task :compile do
    on roles fetch(:breakfast_roles) do |host|
      within release_path do
        with rails_env: "#{fetch(:rails_env) || fetch(:stage)}" do
          execute fetch(:breakfast_yarn_path).to_sym, fetch(:breakfast_yarn_install_command)
          execute :rails, "breakfast:assets:build_production"
          execute :rails, "breakfast:assets:digest"
        end
      end
    end
  end

  desc "Clean out old assets"
  task :clean do
    on roles fetch(:breakfast_roles) do |host|
      within release_path do
        with rails_env: "#{fetch(:rails_env) || fetch(:stage)}" do
          execute :rails, "breakfast:assets:clean"
        end
      end
    end
  end

 after "deploy:updated", "breakfast:compile"
 after "deploy:published", "breakfast:clean"
end


namespace :load do
  task :defaults do
    set :breakfast_roles, -> { :web }
    set :breakfast_yarn_path, "/usr/bin/yarn"
    set :breakfast_yarn_install_comman, "install"
  end
end
