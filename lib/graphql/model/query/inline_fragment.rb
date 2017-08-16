module GraphQL::Model
  module Query
    class InlineFragment
      attr_accessor :type, :selection

      def initialize(type, parent: parent, &block)
        self.type = type
        self.selection = Selection.query(parent: parent, &block) if block_given?
      end

      def to_query
        [:"... on #{type}", selection.to_query]
      end
    end
  end
end