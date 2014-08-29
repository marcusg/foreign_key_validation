require "rails/all"
require 'foreign_key_validation'
require 'rspec/rails'
require 'pry'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.infer_base_class_for_anonymous_controllers = true

  # config.order = 'random'
end

setup_sqlite_db = lambda do
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
  load "schema.rb"
end
silence_stream(STDOUT, &setup_sqlite_db)