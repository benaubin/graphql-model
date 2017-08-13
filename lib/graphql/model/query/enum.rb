require 'active_support/core_ext/string/inflections'

module GraphQL::Model
  module Query
    class Enum
      attr_accessor :value

      def initialize(value)
        self.value = value
      end

      class << self
        def method_missing(method, *_)
          new(method)
        end
      end

      def to_query
        [value]
      end

      def to_query_arg
        value.to_s
      end
    end
  end
end