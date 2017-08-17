require 'active_support/concern'

module GraphQL::Model
  # Allows a GraphQL::Model create a fragment
  module Fragmentable
    extend ActiveSupport::Concern

    included do
      # query_helper(:fragment) do |name|
      #   fragment = tracked_fragment(name)
      #   Proc.new { fragment }
      # end
    end

    class_methods do
      # a hash of the tracked_fragments
      def tracked_fragments
        @tracked_fragments ||= {}
      end

      # get & set the type of this model as used in the schema
      def schema_type(type: nil)
        (@schema_type = type) || self.name
      end

      # an accessor for the tracked_fragments hash.
      #
      # using tracked fragments allows us to know where in a query a fragment was included, later allowing
      # the response to be converted into the model.
      def tracked_fragment(query)
        tracked_fragments[query] ||= Query::TrackedFragment.new(fragment)
      end

      # returns a fragment for retrieving the attributes of the model
      def fragment
        @fragment ||= Query::Fragment.new "#{name}Fields".to_sym, schema_type.to_sym, selection
      end

      def selection
        return @selection unless @selection.nil?

        @selection = Query::Selection.new
        @selection.fields = attributes.map { |attr| attribute_field(attr) }
        @fragment = nil
        @selection
      end

      def model_fragments_to_model!(paths, data)
        paths.each do |path|
          model_parent = path[0..-2].inject(data) { |obj, part| obj[part] }
          model_data = model_parent[path[-1]]

          if model_data.is_a? Array
            model_data.map! { |d| self.from_fields d }
          else
            model_parent[path[-1]] = self.from_fields model_data
          end
        end
        data
      end
    end
  end
end