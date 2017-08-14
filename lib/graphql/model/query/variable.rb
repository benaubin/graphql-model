require 'active_support/core_ext/string/inflections'

module GraphQL::Model
  module Query
    class Variable
      attr_accessor :name, :type, :default_value, :required

      def initialize(name, t, required)
        self.name = name
        self.required = required
        if t.is_a? Hash
          self.type = t.keys.first
          self.default_value = t[type]
        else
          self.type = t
        end
      end

      def to_query
        [self]
      end

      def variable_name
        "$#{name}#{required ? '!' : ''}"
      end
      alias :to_s            :variable_name
      alias :to_query_arg    :variable_name

      def definition
        definition = "#{variable_name}: #{type}"
        definition << " = #{default_value.to_query_arg}" unless self.default_value.nil?
        definition
      end

      def inspect
        "#{variable_name}<#{type}>"
      end

      # two variables are equal if their name and type match
      def ==(other)
        other.is_a?(String) ? variable_name == other : name == other.name && type == other.type
      end
    end
  end
end