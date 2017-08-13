require "spec_helper"

RSpec.describe GraphQL::Model::Query::Selection do
  describe "#query" do
    it "can query a field" do
      query = GraphQL::Model::Query::Selection.query do
        person
      end

      expect(query).to be_query([:person])
    end

    it "can query a field in a field" do
      query = GraphQL::Model::Query::Selection.query do
        person do
          name
        end
      end

      expect(query).to be_query([:person, [:name]])
    end

    it "can query a field with an argument" do
      query = GraphQL::Model::Query::Selection.query do
        person(id: 3) do
          name
        end
      end

      expect(query).to be_query([:person, {id: 3}, [:name]])
    end

    it "can query a field with an alias" do
      query = GraphQL::Model::Query::Selection.query do
        ben :person, id: 3 do
          name
        end
      end

      expect(query).to be_query(["ben: person", {id: 3}, [:name]])
    end
  end

  describe "#add_field" do
    it "adds a field" do
      selection = GraphQL::Model::Query::Selection.new
      selection.add_field(:a_field)

      expect(selection).to be_query([:a_field])
    end
  end

  describe "#_" do
    it "includes fragments" do
      person_fields = GraphQL::Model::Query::Fragment.PersonFields :person do
        name
      end

      selection = GraphQL::Model::Query::Selection.query do
        person do
          _ person_fields
        end
      end

      expect(selection).to be_query([:person, [:"...personFields"], "fragment personFields on Person", [:name]])
    end
  end

  describe "#to_s" do
    it "coverts an s-exp to a string" do
      selection = GraphQL::Model::Query::Selection.new
      selection.add_field(:person, id: 3, type: :human) { name }
      selection.add_field(:ben, :person, id: 2) { name }

      expect(selection.to_s).to eq(<<-GRAPHQL)
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

    it "coverts an s-exp with fragments to a string" do
      person_fields = GraphQL::Model::Query::Fragment.PersonFields :person do
        name
      end

      selection = GraphQL::Model::Query::Selection.query do
        person(id: 3, type: :human) do
          _ person_fields
        end
        ben :person, id: 2 do
          _ person_fields
        end
      end

      expect(selection.to_s).to eq(<<-GRAPHQL)
{
  person(id: 3, type: human) {
    ...personFields
  }
  ben: person(id: 2) {
    ...personFields
  }
  fragment personFields on Person {
    name
  }
}
      GRAPHQL
    end

  end
end