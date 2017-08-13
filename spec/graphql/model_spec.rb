require "spec_helper"

RSpec.describe GraphQL::Model do
  it "has a version number" do
    expect(GraphQL::Model::VERSION).not_to be nil
  end

  it "can query a field" do
    query = GraphQL::Model.query do
              person id: 3, type: :human do
                name
              end
              ben :person, id: 2 do
                name
              end
            end

    expect(query.to_s).to eq <<-'GRAPHQL'
{
  person(id: 3, type: human) {
    name
  }
  ben: person(id: 2) {
    name
  }
}
GRAPHQL
  end
end
