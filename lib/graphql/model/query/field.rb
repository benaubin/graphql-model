require 'active_support/core_ext/string/inflections'

module GraphQL::Model
  module Query
    class Field
      attr_accessor :name, :args, :field_alias, :sub_selection

      def initialize(field_alias = nil, name, parent: parent, **args, &block)
        self.name = name
        self.field_alias = field_alias
        self.args = args
        self.sub_selection = Query::Selection.query(parent: parent, &block) if block_given?
      end

      def method_missing(method, *args)
        if method.to_s =~ /^([a-z_]+)=$/i
          args[$1.camelize(:lower).to_sym] = args[0]
        else
          super
        end
      end

      def to_query
        query = []
        if field_alias
          query << field_alias.to_s + ": " + name.to_s
        else
          query << name
        end
        query << args if args.length > 0
        query << sub_selection.to_query if sub_selection
        query
      end
    end
  end
end