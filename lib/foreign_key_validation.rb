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
    validate_against: :user,
    error_message: lambda { |key, reflection_name, object|
      "#{key} of #{reflection_name} does not match #{object.class.name.tableize} #{key}."
    }
  }

  class << self

    def configure
      yield configuration
    end

    def configuration
      @configuration ||= OpenStruct.new(DEFAULT_CONFIG)
    end

    def reset_configuration
      @configuration = nil
    end

  end
end

ActiveRecord::Base.send :include, ForeignKeyValidation::ModelExtension
