require 'spec_helper'

class Person
  attr_accessor :first_name, :last_name, :age
  include PublicAttributes
end

describe PublicAttributes do
  describe "self.public_attributes" do
    it "adds to the list of public attributes" do
      Person.public_attributes :first_name, :last_name
      expect(PublicAttributes.for(Person).size).to eq(2)
    end

    pending "does not add the same attribute more than once"
  end

  describe "#to_public" do
    pending "returns a hash"
    pending "includes only the designated pubcli_attributes"
    pending "calls #to_public on any attribute whos value responds to it"
  end

  describe "#to_json" do
    pending "calls to_public by default"
    pending "calls the superclass's to_json method, if unsafe == true"
  end
end

# TODO: test all_public_attributes with/without rails
# TODO: test self.to_public, which should only work with rails
