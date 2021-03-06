module ForeignKeyValidation

  class Collector
    attr_accessor :options

    def initialize(opt={})
      self.options = opt
      check_params!
    end

    def klass
      @klass ||= options.fetch(:klass)
    end

    def validate_with
      @validate_with ||= Array(options.fetch(:with, reflection_names)).map(&:to_s).reject {|n| n == validate_against}
    end

    def validate_against_key
      @validate_against_key ||= reflections.select {|r| r.name.to_s == validate_against}.first.try(:foreign_key)
    end

    def validate_against
      @validate_against ||= options.fetch(:on, ForeignKeyValidation.configuration.validate_against).to_s
    end

    private

    def reflections
      @reflections ||= klass.reflect_on_all_associations(:belongs_to)
    end

    def reflection_names
      @reflection_names ||= reflections.map {|r| r.name.to_s }
    end

    def check_params!
      raise Errors::NoReleationFoundError.new(klass.name) if reflection_names.empty?
      raise Errors::NoForeignKeyFoundError.new(validate_against, klass.table_name) unless reflection_names.include?(validate_against)
      raise Errors::UnknownRelationError.new(validate_with) unless validate_with.all? {|k| reflection_names.include?(k)}
    end

  end

end
