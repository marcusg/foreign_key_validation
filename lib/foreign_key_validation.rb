require "foreign_key_validation/version"
require "foreign_key_validation/errors"
require "foreign_key_validation/collector"
require "foreign_key_validation/filter"
require "foreign_key_validation/validator"
require "foreign_key_validation/model_extension"

ActiveRecord::Base.send :include, ForeignKeyValidation::ModelExtension
