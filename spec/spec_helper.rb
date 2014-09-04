require "rails/all"
require 'foreign_key_validation'
require 'rspec/rails'
require 'pry'
require 'database_cleaner'


RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.infer_base_class_for_anonymous_controllers = true

  # reset and reload model classes for each run
  config.before(:each) do
    load "support/reset_models.rb"
    load "support/load_models.rb"
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.order = 'random'
end

setup_sqlite_db = lambda do
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
  load "support/schema.rb"
end
silence_stream(STDOUT, &setup_sqlite_db)
