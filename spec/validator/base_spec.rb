require 'spec_helper'

describe ForeignKeyValidation::Validator do

  let(:user) { User.create }
  let(:other_user) { User.create }

  describe ".new" do

    subject { ForeignKeyValidation::Validator }

    it "initializes new validator" do
      expect(subject.new(double(ForeignKeyValidation::Collector), double(Project)))
        .to be_instance_of ForeignKeyValidation::Validator
    end

  end

  describe "#validate" do

    subject { ForeignKeyValidation::Validator }

    it "creates no validations if object is valid" do
      object = Issue.create(user: user, project: Project.create(user: user))
      collector = OpenStruct.new(validate_against_key: :user_id, validate_with: [:project])
      expect(subject.new(collector, object).validate).to be false
    end

    it "creates validations if object is invalid" do
      object = Issue.create(user: user, project: Project.create(user: other_user))
      collector = OpenStruct.new(validate_against_key: :user_id, validate_with: [:project])
      expect(subject.new(collector, object).validate).to be true
    end

  end

end
