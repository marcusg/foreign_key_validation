module ForeignKeyValidation
  module ModelExtension
    extend ActiveSupport::Concern

    included do
      private
      def validate_foreign_key(validate_against_key, reflection_name)
        return if send(reflection_name).try(validate_against_key).nil? or try(validate_against_key).nil?

        if send(reflection_name).send(validate_against_key) != send(validate_against_key)
          errors.add(validate_against_key, "#{validate_against_key} of #{reflection_name} does not match #{self.class.name.tableize} #{validate_against_key}.")
        end
      end
    end

    module ClassMethods
      def validate_foreign_keys(opt={})
        subclasses.map {|klass| klass.send(:validate_foreign_keys, opt)}

        validator = Validator.new(self, opt)
        validator.check

        define_method validator.filter_method_name do
          validator.validate_with.each do |reflection_name|
            validate_foreign_key(validator.validate_against_key, reflection_name)
          end
        end
        private validator.filter_method_name.to_sym

        before_validation validator.filter_method_name
      end
    end
  end
end

ActiveRecord::Base.send :include, ForeignKeyValidation::ModelExtension
