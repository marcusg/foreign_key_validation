module ForeignKeyValidation
  module Errors

    class NoReleationFoundError < StandardError
      def initialize(name)
        super("Can't find any belongs_to relations for #{name} class. Put validation call below association definitions!")
      end
    end

    class NoForeignKeyFoundError < StandardError
      def initialize(validate_against, table_name)
        super("No foreign key for relation #{validate_against} on #{table_name} table!")
      end
    end

    class UnknownRelationError < StandardError
      def initialize(validate_with)
        super("Unknown relation in #{validate_with}!")
      end
    end

  end
end


