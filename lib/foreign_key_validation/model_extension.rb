module ForeignKeyValidation
  module ModelExtension
    extend ActiveSupport::Concern

    included do
      private
      def validate_foreign_key(key_to_validate_against, validation_key)
        relation = validation_key.gsub('_id', '')

        # do not try to validate if self does not respond to relation or one of the keys is nil
        return if !respond_to?(relation) or send(relation).try(key_to_validate_against).nil? or send(key_to_validate_against).nil?

        # add error if keys does not match
        if send(relation).send(key_to_validate_against) != send(key_to_validate_against)
          errors.add(key_to_validate_against, "#{key_to_validate_against} of #{relation} does not match #{self.class.name.tableize} #{key_to_validate_against}")
        end
      end
    end

    module ClassMethods

      def validate_foreign_keys(on: :user_id, with: nil)
        key_to_validate_against = on

        # check if key_to_validate_against is present as column
        raise ArgumentError, "No foreign key #{key_to_validate_against} on #{self.table_name} table!" unless self.column_names.include?(key_to_validate_against.to_s)

        # use provided 'with' array or column_names from self to get all foreign keys
        keys_to_validate_with = (Array(with).map(&:to_s) if with) || self.column_names.select {|n| n.match(/\w_id/)}

        # reject keys that match either the key_to_validate_against or the current class name key (needed for sti models)
        keys_to_validate_with.reject! {|n| n.to_s == key_to_validate_against.to_s || n.to_s == "#{self.class.name.underscore}_id"  }

        define_method "validate_foreign_keys_on_#{key_to_validate_against}" do
          keys_to_validate_with.each do |validation_key|
            validate_foreign_key(key_to_validate_against, validation_key)
          end
        end
        private "validate_foreign_keys_on_#{key_to_validate_against}".to_sym

        # add before filter
        before_validation "validate_foreign_keys_on_#{key_to_validate_against}"

      end

    end

  end

end

ActiveRecord::Base.send :include, ForeignKeyValidation::ModelExtension