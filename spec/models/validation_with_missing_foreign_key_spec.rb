require 'spec_helper'

describe ForeignKeyValidation::ModelExtension do

  let(:user) { User.create }
  let(:other_user) { User.create }

  context "with calling validation and missing foreign key on relation" do

    before do
      Issue.class_eval do
        validate_foreign_keys
      end
    end

    let(:project) { Project.create }
    let(:other_project) { Project.create }
    let(:issue) { Issue.create project: project, user: user }

    it "allow to rewrite user id of issue" do
      issue.user_id = other_user.id
      issue.save
      issue.reload
      expect(issue.user_id).to eq(other_user.id)
    end

    it "allow to rewrite project id of issue" do
      issue.project_id = other_project.id
      issue.save
      issue.reload
      expect(issue.project_id).to eq(other_project.id)
    end

  end

  context "with calling validation and missing foreign key on self" do

    before do
      Issue.class_eval do
        validate_foreign_keys
      end
    end

    let(:project) { Project.create user: user }
    let(:issue) { Issue.create project: project }

    it "does not allow to rewrite user id of issue" do
      issue.user_id = other_user.id
      issue.save
      expect(issue.errors.messages.values.flatten).to include("user_id of project does not match issues user_id.")
      expect(issue.reload.user_id).to_not eq(other_user.id)
    end

    it "does not allow to rewrite user id of issue with random id" do
      issue.user_id = 42
      issue.save
      expect(issue.errors.messages.values.flatten).to include("user_id of project does not match issues user_id.")
      expect(issue.reload.user_id).to_not eq(42)
    end

  end

end
