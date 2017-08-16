require 'active_support/core_ext/string/inflections'
require 'graphql/model/query/variable'
require 'graphql/model/query/top_level_array'

module GraphQL::Model
  module Query
    # A class to extend from to define a query
    class Base
      attr_accessor :_variables, :_getting_vars
      attr_writer :operation_name

      def initialize
        @dependent_fragments = []
      end

      class << self
        # creates a POST-able hash
        def query(operation_name: self.operation_name, **vars)
          {
              operationName: operation_name,
              query: to_query_string,
              variables: vars
          }
        end

        def operation_name
          @operation_name ||= self.name
        end

        def operation_type
          :query
        end

        # retrieve variables, caches result
        def variables
          @variables ||= new.variables
        end

        def variables?
          !@variables.nil?
        end

        def to_query
          @query ||= variables.empty? ? new.query : new.query(**variables)
        end
        
        def to_query_string(indent: '  ')
          to_query.to_query_string(indent: '  ')
        end

        # force retrieve variables
        def variables!
          # to allow the variables to be gotten again
          @variables = nil
          # gets the new variables
          @variables = new.variables
        end

        def required_variables
          @required_variables ||= []
        end
        def required_variables=(v)
          @required_variables = v
        end

        def require_variable(*variables)
          self.required_variables += variables
        end
        alias :require_variables :require_variable
      end

      def variables
        return self.class.variables if self.class.variables?
        self._variables = nil
        self._getting_vars = true
        query
        self._getting_vars = nil
        self._variables
      end

      def query(**vars, &block)
        if _getting_vars
          self._variables = {}
          required_variables = self.class.required_variables
          vars.each do |name, type|
            required = required_variables.include? name
            self._variables[name] = Variable.new(name, type, required)
          end
        elsif block
          arr = [:"#{operation_type} #{operation_name}"]
          arr << (variables.empty? ? ' ' : " (" + variables.values.map(&:definition).join(", ") + ")")
          arr << Selection.query(parent: self, &block).to_query
          arr += @dependent_fragments.flat_map(&:to_query)

          @query = TopLevelArray.new(arr)
        else
          @query
        end
      end
      alias :to_query :query

      def operation_name
        self.class.operation_name
      end
      def operation_type
        self.class.operation_type
      end

      def add_dependent_fragment(fragment)
        return fragment if @dependent_fragments.include? fragment

        @dependent_fragments.push fragment
        fragment
      end
    end
  end
end