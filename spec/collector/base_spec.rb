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

    subject { ForeignKeyValidation::Collector }

    it "returns true for known class" do
      expect(subject.new(klass: Issue).check!).to be true
    end

    it "raises error for class without relations" do
      expect{subject.new(klass: Dummy).check!}.to raise_error(ForeignKeyValidation::Errors::NoReleationFoundError)
    end

  end

end
