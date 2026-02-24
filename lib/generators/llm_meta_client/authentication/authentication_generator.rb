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
        enable_gem "devise"
      end

      def enable_omniauth
        enable_gem "omniauth"
      end

      def enable_omniauth_google_oauth2
        enable_gem "omniauth-google-oauth2"
      end

      def enable_omniauth_rails_csrf_protection
        enable_gem "omniauth-rails_csrf_protection"
      end


      def create_authentication_file
        template "app/models/user.rb"

        template "app/controllers/users/omniauth_callbacks_controller.rb"
        template "app/controllers/users/sessions_controller.rb"

        template "config/initializers/devise.rb"
        template "config/initializers/omniauth.rb"
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

      private

      def enable_gem(gem_name)
        if File.read("Gemfile").include?("gem \"#{gem_name}\"")
          uncomment_lines "Gemfile", /gem "#{gem_name}"/
        else
          gem gem_name
        end
        run "bundle install --quiet"
      end
    end
  end
end
