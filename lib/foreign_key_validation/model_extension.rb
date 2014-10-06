module ForeignKeyValidation
  module ModelExtension
    extend ActiveSupport::Concern

    module ClassMethods

      def validate_foreign_keys(opt={})
        subclasses.map {|klass| klass.send(:validate_foreign_keys, opt)}

        collector = Collector.new(opt.merge(klass: self))
        collector.check!

        Filter.new(collector).before_filter do
          Validator.validate(validate_against_key: collector.validate_against_key, reflection_names: collector.validate_with, object: self)
        end
      end

    end
  end
end
