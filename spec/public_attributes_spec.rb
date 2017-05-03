require 'spec_helper'

describe PublicAttributes do
  let(:test_class) do
    class Person
      def initialize(params = {})
        params.each { |key, value| send "#{key}=", value }
      end

      attr_accessor :first_name, :last_name, :age, :boss
      include PublicAttributes
    end
  end

  after(:each) do
    Object.send(:remove_const, test_class.name)
    PublicAttributes.reset
  end

  describe "self.public_attributes" do
    it "adds to the list of public attributes" do
      test_class.public_attributes :first_name, :last_name
      expect(PublicAttributes.for(test_class).size).to eq(2)
    end

    it "does not add the same attribute more than once" do
      test_class.public_attributes :first_name
      test_class.public_attributes :first_name
      expect(PublicAttributes.for(test_class).size).to eq(1)
    end
  end

  describe "#to_public" do
    let(:person_attributes) do
      { first_name: "john", last_name: "smith", age: 34 }
    end

    before(:each) do
      test_class.public_attributes :first_name, :last_name
    end

    it "returns a hash" do
      person = test_class.new(person_attributes)
      expect(person.to_public.class).to eq(Hash)
    end

    it "includes only the designated public_attributes" do
      person = test_class.new(person_attributes)
      expected = {
        first_name: "john",
        last_name: "smith"
      }
      expect(person.to_public).to eq(expected)
    end

    it "calls #to_public on any attribute whos value responds to it" do
      test_class.public_attributes :boss
      person = test_class.new(person_attributes)
      boss_attributes = person_attributes.merge({ first_name: 'jim' })
      person.boss = test_class.new(boss_attributes)
      expected = {
        first_name: "john",
        last_name: "smith",
        boss: {
          first_name: "jim",
          last_name: "smith",
          boss: nil
        }
      }
      expect(person.to_public).to eq(expected)
    end
  end

  describe "#to_json" do
    pending "calls to_public by default"
    pending "calls the superclass's to_json method, if unsafe == true"
  end
end

# TODO: test all_public_attributes with/without ActiveRecord
# TODO: test self.to_public, which should only work with ActiveRecord
