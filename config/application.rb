require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GrapeRailsTemplate
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # 將 gem 'rack-cors'中間件掛載到整個rails中間件最上層
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*' #允許哪些域名可以對我們網站 跨站訪問
        resource '*', :headers => :any, :methods => :any #[:get, :post, :options]
        # resource表示哪些請求可以過
        # 看network -> request 的 Headers -> Response Headers -> Access-Control-Allow-Methods
        # 就可以看到這邊允許的method是GET, POST....，這邊跟瀏覽器講說哪些請求可以過
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
