module ForeignKeyValidation
  module ModelExtension
    extend ActiveSupport::Concern


    included do
      private
      def validate_foreign_key(opt={})
        Validator.validate(opt.merge(object: self))
      end
    end

    module ClassMethods
      def validate_foreign_keys(opt={})
        subclasses.map {|klass| klass.send(:validate_foreign_keys, opt)}

        collector = Collector.new(opt.merge(klass: self))
        collector.check!

        Filter.new(collector).before_filter do
          collector.validate_with.each do |reflection_name|
            validate_foreign_key(validate_against_key: collector.validate_against_key, reflection_name: reflection_name)
          end
        end

      end
    end
  end
end

ActiveRecord::Base.send :include, ForeignKeyValidation::ModelExtension
