require "spec_helper"

RSpec.describe Graphql::Model do
  it "has a version number" do
    expect(Graphql::Model::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
