require 'active_support/concern'

module GraphQL::Model
  module Queryable
    extend ActiveSupport::Concern

    included do
    end

    class_methods do
      # a hash of cached queries
      def queries
        @queries ||= {}
      end

      def define_query(name, &block)
        fragment = tracked_fragment name

        query_name = name.to_s.camelize + "Query"

        query = Class.new(Query::Base)
        query.send(:define_singleton_method, :name) { query_name }
        query.send(:define_method, :fragment) { fragment }
        query.send(:class_exec, fragment, &block)

        self.send(:define_singleton_method, :"query_#{name}") { |**vars| self.query(name, **vars) }

        queries[name] = query
      end

      def query_hash(name, **vars)
        queries[name].query(**vars)
      end
    end
  end
end