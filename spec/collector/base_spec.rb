require 'spec_helper'

describe ForeignKeyValidation::Collector do

  let(:user) { User.create }
  let(:other_user) { User.create }

  describe ".new" do

    subject { ForeignKeyValidation::Collector }

    it "initializes new validator" do
      expect(subject.new).to be_instance_of ForeignKeyValidation::Collector
    end

  end

  describe "#check!" do

    it "returns true for known class" do
      expect(ForeignKeyValidation::Collector.new(klass: Issue).check!).to be true
    end

    it "raises error for class without relations" do
      expect{ForeignKeyValidation::Collector.new(klass: Dummy).check!}.to raise_error(ForeignKeyValidation::Errors::NoReleationFoundError)
    end

  end

end
