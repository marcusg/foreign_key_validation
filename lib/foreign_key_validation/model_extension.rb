module ForeignKeyValidation
  module ModelExtension
    extend ActiveSupport::Concern

    module ClassMethods

      def validate_foreign_keys(opt={})
        descendants.map {|klass| klass.public_send(:validate_foreign_keys, opt)} if ForeignKeyValidation.configuration.inject_subclasses

        collector = Collector.new(opt.slice(:on, :with).merge(klass: self))

        Filter.new(collector).before_filter do
          Validator.new(collector, self).validate
        end
      end

    end
  end
end
