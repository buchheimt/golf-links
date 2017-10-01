require 'rails_helper'

RSpec.describe Course, type: :model do

  let(:attributes) do {
      name: "Augusta National GC",
      description: "Home of the Masters",
      location: "Augusta, GA"
    }
  end

  let(:missing_name) {attributes.except(:name)}

  it "is valid with valid attributes" do
    expect(Course.new(attributes)).to be_valid
  end

  describe "name" do
    it "is invalid with missing name" do
      expect(Course.new(missing_name)).to_not be_valid
    end
  end
end
