module GraphQL::Model
  module Query
    class TopLevelArray < Array
      def to_query_string(indent: '  ')
        super(indent: indent, level: -1)
      end
      def to_query
        self
      end
    end
  end
end