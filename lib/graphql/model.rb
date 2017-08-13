require "graphql/model/version"
require "graphql/model/query/selection"
require "graphql/model/query/fragment"

module GraphQL
  module Model
    def self.query(&block)
      Query::Selection.query(&block)
    end
  end
end
