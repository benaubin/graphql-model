require "spec_helper"

RSpec.describe GraphQL::Model::Query::Variable do
  describe "#variable_name" do
    it "returns a simple variable name" do
      variable = GraphQL::Model::Query::Variable.new :var, :String, false

      expect(variable.variable_name).to eq("$var")
    end
    it "returns a default variable name" do
      variable = GraphQL::Model::Query::Variable.new :var, {String: "default"}, false

      expect(variable.variable_name).to eq("$var")
    end
    it "returns a required! variable name" do
      variable = GraphQL::Model::Query::Variable.new :var, :String, true

      expect(variable.variable_name).to eq("$var")
    end
  end

  describe "#definition" do
    it "returns a simple variable definition" do
      variable = GraphQL::Model::Query::Variable.new :var, :String, false

      expect(variable.definition).to eq("$var: String")
    end
    it "returns a default variable definition" do
      variable = GraphQL::Model::Query::Variable.new :var, {String: "default"}, false

      expect(variable.definition).to eq('$var: String = "default"')
    end
    it "returns a required variable definition" do
      variable = GraphQL::Model::Query::Variable.new :var, :String, true

      expect(variable.definition).to eq("$var: String!")
    end
    it "returns a required default variable definition" do
      variable = GraphQL::Model::Query::Variable.new :var, {String: "default"}, true

      expect(variable.definition).to eq('$var: String! = "default"')
    end
  end
end