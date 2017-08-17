require 'active_support/concern'
require 'graphql/model/query/field'

module GraphQL::Model
  module AttributeFields
    extend ActiveSupport::Concern

    class_methods do
      # adds attributes & associated methods and fields to a model
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

      # returns the field name for an attribute.
      # for example, the attribute :first_name should be the field "firstName"
      def attribute_field_name(attr)
        attr.to_s.camelize(:lower)
      end

      # Returns a field for an attribute.
      # Will try to call "#{attr}_field" first (for custom fields) before creating the field based on the name.
      def attribute_field(attr)
        method = :"#{attr}_field"

        if self.respond_to? method
          self.send method
        else
          # for some reason, rubymine thinks this is the wrong Field class.
          Query::Field.new attribute_field_name(attr), []
        end
      end

      # Returns an instance of this model from fields returned from the server
      def from_fields(data)
        attrs = {}
        data.each { |k, v| attrs[k.underscore.to_sym] = v }
        self.new(attrs)
      end
    end
  end
end
