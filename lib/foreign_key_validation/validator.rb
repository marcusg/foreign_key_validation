module ForeignKeyValidation

  class Validator

    attr_accessor :validate_against_key, :reflection_names, :object

    def initialize(opt={})
      self.validate_against_key = opt[:validate_against_key]
      self.reflection_names     = opt[:reflection_names]
      self.object               = opt[:object]
    end

    def validate
      reflection_names.each do |reflection_name|
        next unless keys_present?(reflection_name)
        attach_errors(reflection_name) if keys_different?(reflection_name)
      end
    end

    private

    def key_on_relation(relation)
      object.send(relation).try(validate_against_key)
    end

    def key_on_object
      object.try(validate_against_key)
    end

    def keys_present?(relation)
      key_on_object.present? and key_on_relation(relation).present?
    end

    def keys_different?(relation)
      key_on_object != key_on_relation(relation)
    end

    def attach_errors(reflection_name)
      object.errors.add(validate_against_key, "#{validate_against_key} of #{reflection_name} does not match #{object.class.name.tableize} #{validate_against_key}.")
    end

  end

end
