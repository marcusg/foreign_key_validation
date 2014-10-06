require 'spec_helper'

describe ForeignKeyValidation::ModelExtension do

  let(:user) { User.create }
  let(:other_user) { User.create }

  context "with calling private methods from model" do
    before { Issue.send :validate_foreign_keys }

    let(:issue) { Issue.create }

    it "does not allow to call private validate_foreign_keys_on_* methods" do
      expect{issue.validate_foreign_keys_on_user}.to raise_exception(/private method `validate_foreign_keys_on_user' called/)
    end
  end

  context "with calling validation and wrong attributes hash" do

    it "raises error due to wrong :on key" do
      expect{Idea.class_eval { validate_foreign_keys on: :not_existing }}.to raise_error("No foreign key for relation not_existing on ideas table!")
    end

    it "raises error due to not related :on key" do
      expect{Project.class_eval { validate_foreign_keys on: :comment }}.to raise_error("No foreign key for relation comment on projects table!")
    end

    it "raises error due to wrong :with key" do
      expect{Idea.class_eval { validate_foreign_keys with: :not_existing }}.to raise_error('Unknown relation in ["not_existing"]!')
    end

  end

  context "with calling validation and missing relations" do

    it "raises error due to no existing relations" do
      expect{Dummy.class_eval { validate_foreign_keys }}.to raise_error("Can't find any belongs_to relations for Dummy class. Put validation call below association definitions!")
    end

  end

end
