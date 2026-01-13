# frozen_string_literal: true

module LlmMetaClient
  module Generators
    class AuthenticationGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)


      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def enable_devise
        if File.read("Gemfile").include?('gem "devise"')
          uncomment_lines "Gemfile", /gem "devise"/
        else
          gem "devise"
        end
        run "bundle install --quiet"
      end

      def enable_omniauth
        if File.read("Gemfile").include?('gem "omniauth"')
          uncomment_lines "Gemfile", /gem "omniauth"/
        else
          gem "omniauth"
        end
        run "bundle install --quiet"
      end

      def enable_omniauth_google_oauth2
        if File.read("Gemfile").include?('gem "omniauth-google-oauth2')
          uncomment_lines "Gemfile", /gem "omniauth-google-oauth2"/
        else
          gem "omniauth-google-oauth2"
        end
        run "bundle install --quiet"
      end

      def enable_omniauth_rails_csrf_protection
        if File.read("Gemfile").include?('gem "omniauth-rails_csrf_protection')
          uncomment_lines "Gemfile", /gem "omniauth-rails_csrf_protection"/
          run "bundle install --quiet"
        else
          gem "omniauth-rails_csrf_protection"
          run "bundle install --quiet"
        end
      end

      def create_authentication_file
        template "app/models/llm_meta_server_resource.rb"
        template "app/models/user.rb"

        template "app/controllers/users/omniauth_callbacks_controller.rb"
        template "app/controllers/users/sessions_controller.rb"

        template "app/lib/exceptions.rb"

        template "app/views/shared/_api_key_field.html.erb"
        template "app/views/shared/_model_field.html.erb"
        template "app/views/shared/_submit_row.html.erb"

        template "config/initializers/devise.rb"
        template "config/locales/devise.en.yml"
      end

      def configure_authentication_routes
        route <<-RUBY
          devise_for :users, controllers: {
            omniauth_callbacks: "users/omniauth_callbacks",
            sessions: "users/sessions"
          }

          devise_scope :user do
            delete "/logout", to: "users/sessions#destroy", as: :user_logout
            post "/logout", to: "users/sessions#destroy"
          end
        RUBY
      end

      def add_migrations
        migration_template "db/migrate/create_users.rb", "db/migrate/create_users.rb"
      end
    end
  end
end
