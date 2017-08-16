require 'graphql/model/query/base'

module GraphQL::Model
  module Query
    # A class to extend from to define a mutation
    class Mutation < Base
      class << self
        def operation_type
          :mutation
        end
      end
    end
  end
end