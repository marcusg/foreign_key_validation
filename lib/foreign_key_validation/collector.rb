module ForeignKeyValidation

  class Collector
    attr_accessor :options

    DEFAULT_VALIDATE_AGAINST = :user

    def initialize(opt={})
      self.options = opt
    end

    def check!
      raise Errors::NoReleationFoundError.new(klass.name) if reflection_names.empty?
      raise Errors::NoForeignKeyFoundError.new(validate_against, klass.table_name) unless reflection_names.include?(validate_against)
      raise Errors::UnknownRelationError.new(validate_with) unless validate_with.all? {|k| reflection_names.include?(k)}
      true
    end

    def klass
      @klass ||= options[:klass]
    end

    def validate_against
      @validate_against ||= (options[:on] || DEFAULT_VALIDATE_AGAINST).to_s
    end

    def validate_with
      @validate_with ||= ((Array(options[:with]).map(&:to_s) if options[:with]) || reflection_names).reject {|n| n == validate_against}
    end

    def reflections
      @reflections ||= klass.reflect_on_all_associations(:belongs_to)
    end

    def reflection_names
      @reflection_names ||= reflections.map {|r| r.name.to_s }
    end

    def validate_against_key
      @validate_against_key ||= reflections.select {|r| r.name.to_s == validate_against}.first.try(:foreign_key)
    end

  end

end
