require 'spec_helper'

describe ForeignKeyValidation do

  describe ".configuration" do

    subject { ForeignKeyValidation }

    it "initializes configuration as open struct" do
      expect(subject.configuration).to be_instance_of OpenStruct
    end

    it "defaults to true for injecting subclasses" do
      expect(subject.configuration.inject_subclasses).to eq true
    end

    it "defaults to proc for error messages" do
      expect(subject.configuration.error_message).to be_a Proc
      expect(subject.configuration.error_message.call).to match /does not match/
    end

  end

end
