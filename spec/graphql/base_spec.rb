require "spec_helper"

class Character < GraphQL::Model::Base
  attributes :name, :appears_in

  graphql_path "http://graphql-ruby-demo.herokuapp.com/queries"

  define_query :hero do
    def query(episode: :Episode)
      f = fragment
      super do
        hero(episode: episode) do
          _ f
        end
      end
    end
  end
end

RSpec.describe GraphQL::Model::Base do
  describe Character do
    it "queries the server and responds with a parsed result" do
      expect(Character.query_hero(episode: :EMPIRE)).to eq({
        "hero" => Character.new(name: "Luke Skywalker", appears_in: ["NEWHOPE", "EMPIRE", "JEDI"])
      })
    end
  end
end