require "spec_helper"

RSpec.describe String do
  describe("#to_query_arg") do
    it 'coverts a string into a query arg' do
      expect("test".to_query_arg).to eq('"test"')
    end
  end
end

RSpec.describe Integer do
  describe("#to_query_arg") do
    it 'coverts a integer into a query arg' do
      expect(4.to_query_arg).to eq('4')
    end
  end
end

RSpec.describe Float do
  describe("#to_query_arg") do
    it 'coverts a float into a query arg' do
      expect((3.14).to_query_arg).to eq('3.14')
    end
  end
end

RSpec.describe TrueClass do
  describe("#to_query_arg") do
    it 'coverts true into a query arg' do
      expect(true.to_query_arg).to eq('true')
    end
  end
end

RSpec.describe FalseClass do
  describe("#to_query_arg") do
    it 'coverts false into a query arg' do
      expect(false.to_query_arg).to eq('false')
    end
  end
end

RSpec.describe Symbol do
  describe("#to_query_arg") do
    it 'coverts a symbol into an enum-style query arg' do
      expect((:symbol).to_query_arg).to eq('symbol')
    end
    it 'coverts the symbol to lower camel-case' do
      expect((:symbol_value).to_query_arg).to eq("symbolValue")
    end
    it "doesn't covert a symbol to lower camel-case if it has an ! at the end" do
      expect((:symbol_value!).to_query_arg).to eq("symbol_value")
      expect((:"symbol_value!!").to_query_arg).to eq("symbol_value!")
    end
  end
end

RSpec.describe NilClass do
  describe("#to_query_arg") do
    it "coverts nil to a query arg" do
      expect(nil.to_query_arg).to eq('null')
    end
  end
end

RSpec.describe Array do
  describe("#to_query_arg") do
    it "coverts an array to a query arg" do
      expect([].to_query_arg).to eq('[]')
    end
    it "coverts its contents to a query arg" do
      expect(["test", 5, :foo].to_query_arg).to eq('["test", 5, foo]')
    end
  end
end

RSpec.describe Hash do
  describe("#to_query_arg") do
    it "coverts a hash to a query arg" do
      expect({}.to_query_arg).to eq('{}')
    end
    it "coverts its contents to a query arg" do
      expect({type: :test, foo: "bar", potato: 5}.to_query_arg).to eq('{type: test, foo: "bar", potato: 5}')
    end
  end
end