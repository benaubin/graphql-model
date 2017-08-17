module GraphQL::Model
  module Query
    class InlineFragment
      attr_accessor :type, :selection

      def initialize(type, parent: nil, &block)
        self.type = type
        self.selection = Selection.query(parent: parent, cache: false, &block) if block_given?
      end

      def to_query(path)
        [:"... on #{type}", selection.to_query]
      end
    end
  end
end