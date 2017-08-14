require 'active_support/core_ext/string/inflections'
require 'graphql/model/query/included_fragment'

module GraphQL::Model
  module Query
    class Fragment
      attr_accessor :name, :type, :selection

      def initialize(name, type, &block)
        self.name = name
        self.type = type
        self.selection = Query::Selection.query(&block)
      end

      class << self
        def method_missing(name, type = nil, save: true, &block)
          if type
            fragment = Fragment.new(name, type, &block)
            self._fragments[name.to_s.camelize(:lower).to_sym] = fragment if save
            fragment
          else
            self._fragments[name.to_s.camelize(:lower).to_sym]
          end
        end

        def _fragments
          @fragments ||= {}
        end
      end

      def name=(v)
        @name = v
        reset_header_cache
      end
      def type=(v)
        @type = v
        reset_header_cache
      end

      def fragment_name
        @fragment_name ||= name.to_s.camelize(:lower).to_sym
      end
      def type_name
        @type_name ||= type.to_s.camelize.to_sym
      end

      def to_query
        query = [header]
        query << selection.to_query

        @query ||= query
      end

      def included
        @included ||= IncludedFragment.new(self)
      end

      private

      def header
        @header ||= [:fragment, fragment_name, :on, type_name].join(" ")
      end
      def reset_header_cache
        @fragment_name = nil
        @type_name = nil
        @header = nil
        header
      end
    end
  end
end