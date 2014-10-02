module ForeignKeyValidation

  class Filter
    attr_accessor :collector

    def initialize(collector)
      self.collector = collector
    end

    def before_filter(&block)
      collector.klass.send :define_method, filter_name do
        self.instance_eval &block
      end
      collector.klass.send :private, filter_name.to_sym
      collector.klass.send :before_validation, filter_name
    end

    private

    def filter_name
      "validate_foreign_keys_on_#{collector.validate_against}"
    end

  end

end
