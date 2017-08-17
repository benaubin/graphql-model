require 'http'
require 'active_support/concern'

module GraphQL::Model
  module HTTPGraphQLAdapter
    extend ActiveSupport::Concern

    included do
    end

    class_methods do
      def http(&block)
        @http_blocks ||= []
        @http_blocks << block if block
        @http_blocks.inject(HTTP, &:call)
      end

      def graphql_path(path = nil)
        @graphql_path ||= path
      end

      def post(query)
        http.post(graphql_path, json: query)
      end

      alias :send_query :post
    end
  end
end