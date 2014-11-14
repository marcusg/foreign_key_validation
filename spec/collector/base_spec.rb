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

  end

end
