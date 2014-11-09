require "foreign_key_validation/version"
require "foreign_key_validation/errors"
require "foreign_key_validation/collector"
require "foreign_key_validation/filter"
require "foreign_key_validation/validator"
require "foreign_key_validation/model_extension"
require "ostruct"

module ForeignKeyValidation

  DEFAULT_CONFIG = {
    inject_subclasses: true,
    error_message: proc { |validate_against_key, reflection_name, object|
      "#{validate_against_key} of #{reflection_name} does not match #{object.class.name.tableize} #{validate_against_key}."
    }
  }

  class << self
    attr_writer :configuration

    def configure(&blk)
      yield configuration
    end

    def configuration
      @configuration ||= OpenStruct.new(DEFAULT_CONFIG)
    end
  end
end

ActiveRecord::Base.send :include, ForeignKeyValidation::ModelExtension
