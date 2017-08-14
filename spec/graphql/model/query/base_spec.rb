require "spec_helper"

RSpec.describe GraphQL::Model::Query::Base do

  context "child class" do
    let(:starships_query) {
      StarshipFields = GraphQL::Model::Query::Fragment.StarshipFields(:Starship) do
        name
        filmConnection do
          films do
            title
          end
        end
      end
      class StarshipsQuery < GraphQL::Model::Query::Base
        def query(first: {Int: 3})
          super do
            allStarships(first: first) do
              starships do
                _ StarshipFields
              end
            end
          end
        end
      end
      StarshipsQuery
    }
    let(:starships_query_string) {<<-GraphQL
query StarshipsQuery($first: Int) {
  allStarships(first: $first) {
    starships {
      ...starshipFields
    }
  }
}
fragment starshipFields on Starship{
  name
  filmConnection {
    films {
      title
    }
  }
}
GraphQL
    }

    describe ".to_query_string" do
      it "creates a query string" do
        expect(starships_query.to_query_string).to eq(starships_query_string)
      end
    end

    describe '.query' do
      it "creates a POST-able hash" do
        expect(starships_query.query(operation_name: :operation, first: 5)).to eq({
          operation_name: :operation,
          query: starships_query_string,
          variables: { first: 5 }
        })
      end
    end
  end
end