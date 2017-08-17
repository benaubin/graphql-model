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

      def query_data(name, __ignore_errors: false, **vars)
        q = query_hash(name, **vars)
        response = send_query(q).parse.with_indifferent_access
        unless __ignore_errors || response[:errors].nil?
          response[:errors].each do |error|
            loc = error[:locations][0]
            raise ServerParseError.new error[:message], loc[:line], loc[:column], q[:query]
          end
        end
        response[:data]
      end

      def query(name, __ignore_errors: false, **vars)
        data = query_data name, __ignore_errors: __ignore_errors, **vars
        model_fragments_to_model! tracked_fragment(name).paths, data
        data
      end
    end
  end
end