require_relative "boot"

require "rails/all"

require_relative '../lib/middleware/tenant_selector'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EnterpriseBlog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")


    config.middleware.use TenantSelector # Se usar o Devise `config.middleware.insert_before Warden::Manager, TenantSelector`

    # config.middleware.insert_before Warden::Manager, TenantSelector if defined?(Warden)

    # aqui vem o segredo, para cada banco no database.yml, vamos criar um shard e o nome desse shard vai ser igual ao nome do tenant
    config.after_initialize do
      ActiveRecord::Base.connects_to(
        shards: ActiveRecord::Base.configurations.configs_for.select { |c| c.env_name == Rails.env }.reject { |c| c.name == 'tenancy' }.map do |c|
        [c.name.to_sym, { writing: c.name.to_sym }]
      end.to_h)
    end
    # Configure shards based on database.yml
    # config.after_initialize do
    #   ActiveRecord::Base.connects_to(
    #     shards: ActiveRecord::Base.configurations.configs_for.select { |c| c.env_name == Rails.env }
    #                               .reject { |c| c.name == 'tenancy' }
    #                               .map { |c| [c.name.to_sym, { writing: c.name.to_sym }] }
    #                               .to_h
    #   )
    # end
  end
end
