require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.action_dispatch.rescue_responses.merge!(
      { "ActiveRecord::RecordNotFound"   => :not_found, 
        "ActiveRecord::StaleObjectError" => :conflict,
        "ActiveRecord::RecordInvalid"    => :unprocessable_entity,
        "ActiveRecord::RecordNotSaved"   => :unprocessable_entity }
    )
  end
end
