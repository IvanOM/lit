# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'minitest/rails'
require 'rails/test_help'
require 'capybara/rails'
require 'database_cleaner'
require 'test_declarative'
require 'mocha/setup'
require 'factory_girl_rails'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActiveSupport::TestCase.fixture_path = File.expand_path('../fixtures', __FILE__)

## do not enforce available locales
I18n.config.enforce_available_locales = false

# Transactional fixtures do not work with Selenium tests, because Capybara
# uses a separate server thread, which the transactions would be hidden
# from. We hence use DatabaseCleaner to truncate our test database.
DatabaseCleaner.strategy = :transaction

DatabaseCleaner.clean_with :truncation

class ActiveSupport::TestCase
  self.use_transactional_fixtures = false
  setup do
    clear_redis
    Lit.init.cache.reset
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end
  
  teardown do
    DatabaseCleaner.clean
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.strategy = :truncation
    I18n.backend.reload!
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean       # Truncate the database
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
    DatabaseCleaner.strategy = :transaction
  end
end

class ActionController::TestCase
  include Warden::Test::Helpers
  include Devise::TestHelpers
  Warden.test_mode!
  include FactoryGirl::Syntax::Methods
end
