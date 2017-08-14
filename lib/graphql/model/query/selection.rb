require 'graphql/model/core_ext/to_query_string'
require 'graphql/model/query/field'

module GraphQL::Model
  module Query
    class Selection
      attr_accessor :dependent_fragments, :fields, :_parent

      def initialize(parent: nil)
        @fields = []
        @dependent_fragments = []
        @_parent = parent
      end

      class << self
        def query(parent: nil, &block)
          query = Selection.new(parent: parent)
          query.send :instance_exec, &block
          query.to_query
          query
        end
      end

      def method_missing(field_alias = nil, field, **args, &block)
        add_field field_alias, field, args, &block
      end

      def add_field(field_alias = nil, name, **args, &block)
        @query_cache = nil
        fields << Field.new(field_alias, name, parent: self, **args, &block)
      end

      def to_query
        p @dependent_fragments if @dependent_fragments.length > 1
        @query_cache ||= (@fields + @dependent_fragments).flat_map(&:to_query)
      end

      def _(fragment)
        @fields << add_dependent_fragment(fragment).included
      end

      def to_s(*_)
        to_query.to_query_string
      end
      alias :as_json :to_s

      def inspect
        ["#<#{self.class.name}>", to_s].join("\n").gsub("\n", "\n  ")
      end

      def add_dependent_fragment(fragment)
        if _parent
          return _parent.add_dependent_fragment(fragment)
        end
        return fragment if dependent_fragments.include? fragment

        @query_cache = nil
        dependent_fragments.push fragment
        fragment
      end
    end
  end
end
