require 'active_support/core_ext/string/inflections'
require 'graphql/model/query/included_fragment'

module GraphQL::Model
  module Query
    class IncludedFragment
      attr_accessor :fragment

      def initialize(fragment)
        self.fragment = fragment
      end

      def to_query(path = [])
        fragment.included!(path) if fragment.respond_to? :included!

        [:"...#{fragment.fragment_name}"]
      end
    end
  end
end