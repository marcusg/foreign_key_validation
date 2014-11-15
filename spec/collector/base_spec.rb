require 'spec_helper'

describe ForeignKeyValidation::Collector do

  describe ".new" do

    subject { ForeignKeyValidation::Collector }

    it "initializes new validator when class is present" do
      expect(subject.new(klass: Issue)).to be_instance_of ForeignKeyValidation::Collector
    end

    it "raises error for class without relations" do
      expect{subject.new(klass: Dummy)}.to raise_error(ForeignKeyValidation::Errors::NoReleationFoundError)
    end

    describe "instance methods" do
      subject { ForeignKeyValidation::Collector.new(klass: Issue) }

      it "provides access to #klass" do
        expect(subject.klass).to be Issue
      end

      it "provides access to #validate_with" do
        expect(subject.validate_with).to eq ["project"]
      end

      it "provides access to #validate_against_key" do
        expect(subject.validate_against_key).to eq "user_id"
      end

      it "provides access to #validate_against" do
        expect(subject.validate_against).to eq "user"
      end

    end

  end

end
