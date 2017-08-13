require "spec_helper"

RSpec.describe Object do
  describe("#to_query_string") do
    it 'coverts a symbol into a query string' do

      expect((:field).to_query_string(level: 1)).to eq("\n  field")
    end
  end
end

RSpec.describe Array do
  describe("#to_query_string") do
    it 'coverts an array into a query string' do
      expect([:field].to_query_string).to eq("{\n  field\n}\n")
    end
    it 'coverts a multi-level array into a query string' do
      expect([:field, [:field]].to_query_string).to eq("{\n  field {\n    field\n  }\n}\n")
    end
  end
end

RSpec.describe Hash do
  describe("#to_query_string") do
    it 'converts a hash to a query argument' do
      expect({type: :foo, amount: 1, correct: true, potatoes: ["green", "ripe"]}.to_query_string).to(
        eq('(type: foo, amount: 1, correct: true, potatoes: ["green", "ripe"])'))
    end
  end
end