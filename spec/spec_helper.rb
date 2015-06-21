require 'coveralls'
Coveralls.wear!

require 'active_support'
require 'active_record'
require 'foreign_key_validation'
require 'rspec'
require 'database_cleaner'
require 'pry'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # reset and reload model classes for each run
  config.before(:each) do
    ForeignKeyValidation.reset_configuration
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

respond_to?(:silence_stream) ? silence_stream(STDOUT, &setup_sqlite_db) : setup_sqlite_db.call
