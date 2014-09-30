module ForeignKeyValidation

  class Validator
    attr_accessor :klass, :validate_against, :reflections, :reflection_names, :validate_against_key, :validate_with

    DEFAULT_VALIDATE_AGAINST = :user

    def initialize(klass, opt={})
      self.klass                 = klass
      self.validate_against      = find_validate_against(opt[:on])
      self.reflections           = klass.reflect_on_all_associations(:belongs_to)
      self.reflection_names      = reflections.map(&:name).map(&:to_s)
      self.validate_against_key  = find_validate_against_key
      self.validate_with         = find_validate_with(opt[:with])
    end

    def check
      raise Errors::NoReleationFoundError.new(klass.name) if reflection_names.empty?
      raise Errors::NoForeignKeyFoundError.new(validate_against, klass.table_name) unless reflection_names.include?(validate_against)
      raise Errors::UnknownRelationError.new(validate_with) unless validate_with.all? {|k| reflection_names.include?(k)}
    end

    def filter_method_name
      "validate_foreign_keys_on_#{validate_against}"
    end

    private

    def find_validate_against(opt_on)
      (opt_on || DEFAULT_VALIDATE_AGAINST).to_s
    end

    def find_validate_with(opt_with)
      ((Array(opt_with).map(&:to_s) if opt_with) || reflection_names).reject {|n| n == validate_against}
    end

    def find_validate_against_key
      reflections.select {|r| r.name.to_s == validate_against}.first.try(:foreign_key)
    end

  end

end
