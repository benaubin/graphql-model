require "spec_helper"

RSpec.describe GraphQL::Model::Query::Fragment do
  describe "#new" do
    it "can query a field" do
      person_fields = GraphQL::Model::Query::Fragment.new :person_fields, :person do
        name
      end

      expect(person_fields.to_query).to eq(["fragment personFields on Person", [:name]])
    end
  end
end