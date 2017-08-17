require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'

module GraphQL::Model
  module Query
    class TrackedFragment
      attr_accessor :fragment, :paths

      delegate :name, :type, :selection, :name=, :type=, :fragment_name, :type_name, :to_query, to: :fragment

      def initialize(fragment)
        @fragment = fragment
        @paths = []
      end

      def included!(path)
        p path
        paths << path unless paths.include?(path)
      end

      def included
        @included ||= IncludedFragment.new(self)
      end
    end
  end
end