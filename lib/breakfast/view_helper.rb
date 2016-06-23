module Breakfast
  module ViewHelper
    def breakfast_autoreload_tag
      if Rails.configuration.breakfast.environments.include?(Rails.env)
        content_tag :script do
          <<-SCRIPT.html_safe
            require("breakfast-rails").init({
              host: "#{request.host}",
              port: #{request.port},
              reloadStrategies: {
                js: "#{Rails.configuration.breakfast.js_reload_strategy}",
                css: "#{Rails.configuration.breakfast.css_reload_strategy}",
                html: "#{Rails.configuration.breakfast.html_reload_strategy}"
              }
            });
          SCRIPT
        end
      end
    end
  end
end
