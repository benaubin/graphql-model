require "spec_helper"

RSpec.describe GraphQL::Model::Query::Base do
  context "child class" do
    let(:create_starship) {
      class CreateStarship < GraphQL::Model::Query::Mutation
        require_variable :starship
        def query(starship: :StarshipInput)
          super do
            createStarship(starship: starship) do
              id
            end
          end
        end
      end
      CreateStarship
    }
    let(:starships_mutation_string) {<<-GraphQL
mutation CreateStarship ($starship: StarshipInput!){
  createStarship(starship: $starship) {
    id
  }
}
    GraphQL
    }

    describe ".to_query_string" do
      it "creates a query string" do
        expect(create_starship.to_query_string).to eq(starships_mutation_string)
      end
    end

    describe '.query' do
      it "creates a POST-able hash" do
        expect(create_starship.query(starship: {name: "The Newest Ship"})).to eq({
                                                                                    operation_name: "CreateStarship",
                                                                                    query: starships_mutation_string,
                                                                                    variables: { starship: {
                                                                                        name: "The Newest Ship"
                                                                                    }}
                                                                                  })
      end
    end
  end
end