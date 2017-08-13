require 'active_support/core_ext/string/inflections'
require 'graphql/model/query/included_fragment'

module GraphQL::Model
  module Query
    class Fragment
      attr_accessor :name, :type, :selection

      def initialize(name, type, cache: true, &block)
        self.name = name
        self.type = type
        self.selection = Query::Selection.query(&block)

        self.cache cache
      end

      class << self
        def method_missing(name, type, cache: true, &block)
          Fragment.new(name, type, cache: cache, &block)
        end
      end

      def name=(v)
        reset_header
        @name = v
      end
      def type=(v)
        reset_header
        @type = v
      end

      def fragment_name
        @fragment_name ||= name.to_s.camelize(:lower).to_sym
      end
      def type_name
        @type_name ||= type.to_s.camelize.to_sym
      end

      def cache(should_cache = nil)
        if should_cache.nil?
          @cache && @query
        elsif should_cache
          @cache = true
          to_query
        else
          @cache = false
          @query = nil
        end
      end

      def to_query
        query = [header]
        query << selection.to_query

        cache || (@query = query)
      end

      def included
        @included ||= IncludedFragment.new(self)
      end

      private

      def header
        @header ||= [:fragment, fragment_name, :on, type_name].join(" ")
      end
      def reset_header
        @fragment_name = nil
        @type_name = nil
        @header = nil
      end
    end
  end
end