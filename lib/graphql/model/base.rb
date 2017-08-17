require 'active_model'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/hash/indifferent_access'
require 'graphql/model/query/field'
require 'graphql/model/query/tracked_fragment'

require 'graphql/model/http_graphql_adapter'
require 'graphql/model/fragmentable'
require 'graphql/model/queryable'

module GraphQL
  module Model
    class Error < StandardError; end

    class ServerParseError < Error
      def initialize(message, line, col, query)
        super(message + " at #{line}:#{col}")
      end
    end

    class Base
      include ActiveModel::Model
      include ActiveModel::Dirty
      include ActiveModel::AttributeMethods

      include HTTPGraphQLAdapter
      include Fragmentable
      include Queryable

      attribute_method_suffix :_field, :_field_name

      def initialize(**_)
        super
      end

      class << self
        def from_data(data)
          attrs = {}
          data.each { |k, v| attrs[k.underscore.to_sym] = v }
          self.new(attrs)
        end

        def attributes(*attrs)
          unless attrs.empty?
            define_attribute_methods *attrs
            self.send :attr_accessor, *attrs

            @selection = nil
            @fragment = nil
            @attributes = (@attributes || []).concat attrs.map(&:to_sym)
          end
          @attributes ||= []
        end

        def graphql_type(type: nil)
          (@graphql_type = type) || self.name
        end

        def selection
          return @selection unless @selection.nil?

          @selection = Query::Selection.new
          @selection.fields = attributes.map { |attr| attribute_field(attr) }
          @fragment = nil
          @selection
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

        def model_fragments_to_model!(paths, data)
          paths.each do |path|
            model_parent = path[0..-2].inject(data) { |obj, part| obj[part] }
            model_data = model_parent[path[-1]]

            if model_data.is_a? Array
              model_data.map! { |d| self.from_data d }
            else
              model_parent[path[-1]] = self.from_data model_data
            end
          end
          data
        end

        def attribute_field_name(attr)
          attr.to_s.camelize(:lower)
        end

        def attribute_field(attr, field_alias: nil, __directives: [], **args, &block)
          method = :"#{attr}_field"

          if self.respond_to? method
            # allow this to be overwritten.
            self.send method, field_alias, __directives, **args, &block
          else
            # for some reason, rubymine thinks this is the wrong Field class.
            # noinspection RubyArgCount
            (Query::Field).new field_alias, attribute_field_name(attr), __directives, **args, &block
          end
        end
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
  end
end
