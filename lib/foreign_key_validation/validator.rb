module ForeignKeyValidation

  class Validator

    attr_accessor :collector, :object

    def initialize(collector, object)
      self.collector  = collector
      self.object     = object
    end

    def validate
      to_enum(:invalid_reflection_names).map {|n| attach_error(n) }.any?
    end

    private

    def invalid_reflection_names(&block)
      (validate_with || []).each do |reflection_name|
        next unless keys_present?(reflection_name)
        yield reflection_name if keys_different?(reflection_name)
      end
    end

    def key_on_relation(relation)
      object.public_send(relation).try(validate_against_key)
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

    def attach_error(reflection_name)
      object.errors.add(validate_against_key, error_message(reflection_name))
    end

    def error_message(reflection_name)
      ForeignKeyValidation.configuration.error_message.call(validate_against_key, reflection_name, object)
    end

    def validate_against_key
      collector.validate_against_key
    end

    def validate_with
      collector.validate_with
    end

  end

end
