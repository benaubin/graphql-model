require 'active_model'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/hash/indifferent_access'
require 'graphql/model/query/tracked_fragment'

require 'graphql/model/http_graphql_adapter'
require 'graphql/model/fragmentable'
require 'graphql/model/queryable'
require 'graphql/model/attribute_fields'

module GraphQL
  module Model
    class Error < StandardError; end

    class ServerParseError < Error
      def initialize(message, line, col, query)
        super(message + " at #{line}:#{col}")
      end
    end

    # Serverless models don't have a `#send_query` adapter and need one to be able to... send queries (and mutations).
    class Serverless
      include ActiveModel::Model
      include ActiveModel::Dirty
      include ActiveModel::AttributeMethods

      include Fragmentable
      include Queryable
      include AttributeFields

      attribute_method_suffix :_field, :_field_name

      def initialize(**_)
        super
      end

      def ==(other)
        self.to_h == other.to_h
      end

      def to_h
        attributes.inject({}) { |obj, attr| obj.merge(a: self.send(attr)) }
      end

      protected

      def attributes
        self.class.attributes
      end

      def attribute_field_name(attr)
        self.class.attribute_field_name(attr)
      end

      def attribute_field(attr)
        self.class.attribute_field_name(attr)
      end
    end

    # A model backed by a HTTP-based GraphQL API
    class Base < Serverless
      include HTTPGraphQLAdapter
    end
  end
end
