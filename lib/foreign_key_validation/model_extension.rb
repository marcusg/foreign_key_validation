module ForeignKeyValidation
  module ModelExtension
    extend ActiveSupport::Concern

    included do
      private
      def validate_foreign_key(validate_against, relation)
        return if send(relation).try("#{validate_against}_id").nil? or try("#{validate_against}_id").nil?

        if send(relation).send("#{validate_against}_id") != send("#{validate_against}_id")
          errors.add(validate_against, "#{validate_against} of #{relation} does not match #{self.class.table_name} #{validate_against}")
        end
      end
    end

    module ClassMethods
      def validate_foreign_keys(opt={})
        validate_against  = (opt[:on] || :user).to_s
        reflections       = reflect_on_all_associations(:belongs_to).map(&:name).map(&:to_s)
        validate_with     = ((Array(opt[:with]).map(&:to_s) if opt[:with]) || reflections).reject {|n| n == validate_against}

        raise ArgumentError, "No foreign key #{validate_against} on #{table_name} table!" unless reflections.include?(validate_against)
        raise ArgumentError, "Unknown relation in #{validate_with}!" unless validate_with.all? {|k| reflections.include?(k) }

        define_method "validate_foreign_keys_on_#{validate_against}" do
          validate_with.each do |relation|
            validate_foreign_key(validate_against, relation)
          end
        end
        private "validate_foreign_keys_on_#{validate_against}".to_sym

        before_validation "validate_foreign_keys_on_#{validate_against}"
      end
    end
  end
end

ActiveRecord::Base.send :include, ForeignKeyValidation::ModelExtension
