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
  describe "#query_[query]" do
    it "queries the server and responds with a parsed result" do
      # noinspection RubyStringKeysInHashInspection
      expect(Character.query_hero(episode: :EMPIRE)).to eq({
        "hero" => Character.new(name: "Luke Skywalker", appears_in: ["NEWHOPE", "EMPIRE", "JEDI"])
      })
    end
  end
  describe "#to_h" do
    it "returns the data of a model" do
      expect(Character.new(name: "Darth Vader").to_h).to eq({name: "Darth Vader", appears_in: nil})
    end
  end
  describe "#==" do
    context "when both models are equal" do
      it "returns true" do
        expect(Character.new(name: "Percy Jackson")).to eq(Character.new(name: "Percy Jackson"))
      end
    end
    context "when both models aren't equal" do
      it "returns false" do
        expect(Character.new(name: "Percy Jackson") == Character.new(name: "Ron Weasley")).to be_falsey
      end
    end
  end
end