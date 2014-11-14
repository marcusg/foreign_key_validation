require 'spec_helper'

describe ForeignKeyValidation do

  describe ".configuration" do

    it "initializes configuration as open struct" do
      expect(subject.configuration).to be_instance_of OpenStruct
    end

    it "defaults to true for injecting subclasses" do
      expect(subject.configuration.inject_subclasses).to eq true
    end

    it "defaults to proc for error messages" do
      expect(subject.configuration.error_message).to be_a Proc
      expect(subject.configuration.error_message.call(nil,nil,nil)).to match /does not match/
    end

    it "defaults to :user for validate against key" do
      expect(subject.configuration.validate_against).to eq :user
    end

    it "defaults to nil for unknown config options" do
      expect(subject.configuration.foo_bar).to eq nil
    end

  end

  describe ".configure" do

    it "allow change of inject_subclasses config" do
      subject.configure {|c| c.inject_subclasses = false}
      expect(subject.configuration.inject_subclasses).to eq false
    end

    it "allow change of error_message config" do
      subject.configure {|c| c.error_message = proc { "MY MSG" }}
      expect(subject.configuration.error_message.call).to eq "MY MSG"
    end

    it "allow change of validate_against config" do
      subject.configure {|c| c.validate_against = :my_user}
      expect(subject.configuration.validate_against).to eq :my_user
    end

  end

  describe ".reset_configuration" do

    it "allow reset of config" do
      subject.configure {|c| c.validate_against = :my_user}
      subject.reset_configuration
      expect(subject.configuration.validate_against).to eq :user
    end

  end

end
