module Breakfast
  module ViewHelper
    def breakfast_autoreload_tag
      if Rails.configuration.breakfast.environments.include?(Rails.env)
        content_tag :script do
          <<-SCRIPT.html_safe
            require("breakfast-rails").init({
              host: "#{request.host}",
              port: #{request.port},
              strategies: {
                js: "#{Rails.configuration.breakfast.js_reload_strategy}",
                css: "#{Rails.configuration.breakfast.css_reload_strategy}",
                html: "#{Rails.configuration.breakfast.html_reload_strategy}",
                rb: "#{Rails.configuration.breakfast.ruby_reload_strategy}"
              },
              statusBarLocation: "#{Rails.configuration.breakfast.status_bar_location}"
            });
          SCRIPT
        end
      end
    end

    include ActionView::Helpers::AssetUrlHelper
    include ActionView::Helpers::AssetTagHelper

    def compute_asset_path(path, options = {})
      if Rails.configuration.breakfast.digest && Rails.configuration.breakfast.manifest.asset(path)
        path = Rails.configuration.breakfast.manifest.asset(path)
      end

      super(path, options)
    end
  end
end
