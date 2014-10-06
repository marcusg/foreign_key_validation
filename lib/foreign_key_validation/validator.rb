module ForeignKeyValidation

  class Validator

    def self.validate(opt={})
      validate_against_key, reflection_names, object = opt[:validate_against_key], opt[:reflection_names], opt[:object]

      reflection_names.each do |reflection_name|
        next if object.send(reflection_name).try(validate_against_key).nil? or object.try(validate_against_key).nil?

        if object.send(reflection_name).send(validate_against_key) != object.send(validate_against_key)
          object.errors.add(validate_against_key, "#{validate_against_key} of #{reflection_name} does not match #{object.class.name.tableize} #{validate_against_key}.")
        end
      end
    end

  end

end
