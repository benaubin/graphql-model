require 'graphql/model/core_ext/to_query_string'
require 'graphql/model/query/field'
require 'graphql/model/query/directive'
require 'graphql/model/query/inline_fragment'

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
        def query(parent: nil, cache: true, &block)
          query = Selection.new(parent: parent)
          query.send :instance_exec, &block
          query.to_query if cache
          query
        end
      end

      def method_missing(*args, **opts, &block)
        name, field_alias = args.reverse.drop_while{ |a| a.is_a? Directive }
        directives        = args.select            { |a| a.is_a? Directive }

        if field_alias.nil? && directives.empty? && (name.to_s =~ /(on)?_(\w+)?/)
          if $1
            fields << InlineFragment.new($2, parent: self, &block)
          else
            Directive.new(name, opts)
          end
        else
          if name.is_a? Directive
            super if name.nil?
            directives = [name] + directives
            name = field_alias
            field_alias = nil
          end
          field_alias = nil if field_alias == name

          add_field field_alias, name, directives: directives, **opts, &block
        end
      end

      def add_field(field_alias = nil, name, directives: [], **args, &block)
        @query_cache = nil
        fields << Field.new(field_alias, name, directives, __parent: self, **args, &block)
      end

      def to_query(path = [])
        @query_cache ||= (@fields + @dependent_fragments).flat_map{ |f| f.to_query(path.dup) }
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
