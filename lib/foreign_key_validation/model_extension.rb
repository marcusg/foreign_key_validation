module ForeignKeyValidation
  module ModelExtension
    extend ActiveSupport::Concern

    included do
      private
      def validate_foreign_key(validate_against_key, reflection_name)
        return if send(reflection_name).try(validate_against_key).nil? or try(validate_against_key).nil?

        if send(reflection_name).send(validate_against_key) != send(validate_against_key)
          errors.add(validate_against_key, "#{validate_against_key} of #{reflection_name} does not match #{self.class.name.tableize} #{validate_against_key}")
        end
      end
    end

    module ClassMethods
      def validate_foreign_keys(opt={})
        subclasses.map {|klass| klass.send(:validate_foreign_keys, opt) } if subclasses.any?

        validate_against      = (opt[:on] || :user).to_s
        reflections           = reflect_on_all_associations(:belongs_to)
        reflection_names      = reflections.map(&:name).map(&:to_s)
        validate_against_key  = reflections.select {|r| r.name.to_s == validate_against}.first.try(:foreign_key)
        validate_with         = ((Array(opt[:with]).map(&:to_s) if opt[:with]) || reflection_names).reject {|n| n == validate_against}

        raise ArgumentError, "Can't find any belongs_to relations for #{name} class. Put validation call below association definitions" if reflection_names.empty?
        raise ArgumentError, "No foreign key for relation #{validate_against} on #{table_name} table!" unless reflection_names.include?(validate_against)
        raise ArgumentError, "Unknown relation in #{validate_with}!" unless validate_with.all? {|k| reflection_names.include?(k) }

        define_method "validate_foreign_keys_on_#{validate_against}" do
          validate_with.each do |reflection_name|
            validate_foreign_key(validate_against_key, reflection_name)
          end
        end
        private "validate_foreign_keys_on_#{validate_against}".to_sym

        before_validation "validate_foreign_keys_on_#{validate_against}"
      end
    end
  end
end

ActiveRecord::Base.send :include, ForeignKeyValidation::ModelExtension
