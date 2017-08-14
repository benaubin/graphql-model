require 'active_support/core_ext/string/inflections'

module GraphQL::Model
  module Query
    class Directive
      attr_accessor :name, :args

      def initialize(name, args)
        self.name = name.to_s.sub("_", "@").to_sym
        self.args = args
      end

      def to_s
        to_query.to_query_string
      end

      def to_query
        [" #{name}", args]
      end

      #alias :inspect         :to_s

      # two directives are equal if their string representations match
      def ==(other)
        other = other.to_s unless other.is_a?(String)
        to_s == other
      end
    end
  end
end