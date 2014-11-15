require 'spec_helper'

describe ForeignKeyValidation::Validator do

  let(:user) { User.create }
  let(:other_user) { User.create }
  let(:collector) { double(ForeignKeyValidation::Collector) }

  describe ".new" do

    let(:project) { double(Project) }

    subject { ForeignKeyValidation::Validator }

    it "initializes new validator" do
      expect(subject.new(collector, project)).to be_instance_of ForeignKeyValidation::Validator
    end

  end

  describe "#validate" do
    let(:valid_issue) { Issue.create(user: user, project: Project.create(user: user)) }
    let(:invalid_issue) { Issue.create(user: user, project: Project.create(user: other_user)) }

    before do
      allow(collector).to receive(:validate_against_key).and_return :user_id
      allow(collector).to receive(:validate_with).and_return [:project]
    end

    subject { ForeignKeyValidation::Validator }

    it "creates no validations if object is valid" do
      expect(subject.new(collector, valid_issue).validate).to be false
    end

    it "creates validations if object is invalid" do
      expect(subject.new(collector, invalid_issue).validate).to be true
    end

  end

end
