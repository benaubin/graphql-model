require "spec_helper"

RSpec.describe GraphQL::Model::Query::Fragment do
  describe "[FragmentName]" do
    it 'can define new fragments' do
      person_fields = GraphQL::Model::Query::Fragment.PersonFields :person do
        name
      end

      query = GraphQL::Model.query do
        person do
          _ person_fields
        end
      end

      expect(query).to be_query([:person, [:"...personFields"], "fragment personFields on Person", [:name]])
    end

    it 'can access defined fragments' do
      GraphQL::Model::Query::Fragment.PersonFields :person do
        name
      end

      person_fields = GraphQL::Model::Query::Fragment.PersonFields

      expect(person_fields).to be_query(["fragment personFields on Person", [:name]])
    end
  end

  describe "#new" do
    it "can query a field" do
      person_fields = GraphQL::Model::Query::Fragment.new :person_fields, :person do
        name
      end

      expect(person_fields.to_query).to eq(["fragment personFields on Person", [:name]])
    end
  end
end