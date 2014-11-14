module ForeignKeyValidation
  module ModelExtension
    extend ActiveSupport::Concern

    module ClassMethods

      def validate_foreign_keys(opt={})
        descendants.map {|klass| klass.public_send(:validate_foreign_keys, opt)} if ForeignKeyValidation.configuration.inject_subclasses

        collector = Collector.new(opt.merge(klass: self))
        collector.check!

        Filter.new(collector).before_filter do
          Validator.new(validate_against_key: collector.validate_against_key, reflection_names: collector.validate_with, object: self).validate
        end
      end

    end
  end
end
