require 'spec_helper'

describe ForeignKeyValidation::Validator do

  let(:user) { User.create }
  let(:other_user) { User.create }

  describe ".new" do

    subject { ForeignKeyValidation::Validator }

    it "initializes new validator" do
      expect(subject.new).to be_instance_of ForeignKeyValidation::Validator
    end

  end

  describe "#validate" do

    subject { ForeignKeyValidation::Validator }

    it "creates no validations if params blank" do
      expect(subject.new.validate).to be false
    end

    it "creates no validations if object is valid" do
      object = Issue.create(user: user, project: Project.create(user: user))
      expect(subject.new(validate_against_key: :user_id, reflection_names: [:project], object: object).validate).to be false
    end

    it "creates validations if object is invalid" do
      object = Issue.create(user: user, project: Project.create(user: other_user))
      expect(subject.new(validate_against_key: :user_id, reflection_names: [:project], object: object).validate).to be true
    end

  end

end
