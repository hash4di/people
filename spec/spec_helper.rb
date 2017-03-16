if ENV['CI']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'sucker_punch/testing/inline'
require 'capybara/rspec'
require 'rack_session_access/capybara'
require 'database_cleaner'
require 'selenium-webdriver'
require 'site_prism'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'

Dir["./spec/support/sections/*.rb"].each { |f| require f }
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  I18n.enforce_available_locales = false

  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.include Helpers::JSONResponse, type: :controller
  config.include Capybara::DSL

  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, job: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    Timecop.return
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = false
end

# we have problems with geckodriver and newest version of firefox(52) new configuration is added to circle.yml in dependencies: pre: state
if ENV['CI']
  Selenium::WebDriver::Firefox::Binary.path = '/home/ubuntu/people/firefox/firefox'
end

Capybara.default_max_wait_time = 5

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app)
end

Capybara.javascript_driver = :selenium
