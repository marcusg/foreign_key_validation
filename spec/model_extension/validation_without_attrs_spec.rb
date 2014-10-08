require 'spec_helper'

describe ForeignKeyValidation::ModelExtension do

  let(:user) { User.create }
  let(:other_user) { User.create }

  context "with calling validation" do
    before do
      Idea.send :validate_foreign_keys
      Project.send :validate_foreign_keys
      Issue.send :validate_foreign_keys
      Comment.send :validate_foreign_keys
      Member.send :validate_foreign_keys
    end

    let(:project) { Project.create user: user }
    let(:other_project) { Project.create user: other_user }
    let(:idea) { Idea.create user: user, project: project }
    let(:issue) { Issue.create user: user, project: project }
    let(:other_issue) { Issue.create user: other_user, project: other_project }
    let(:comment) { Comment.create user: user, issue: issue }
    let(:manager) { Manager.create user: user }
    let(:other_manager) { Manager.create user: User.create }
    let(:developer) { Developer.create user: user, boss: manager }

    it "uses same user ids by default" do
      expect(project.user_id).to eq(user.id)
      expect(idea.user_id).to eq(user.id)
      expect(issue.user_id).to eq(user.id)
      expect(comment.user_id).to eq(user.id)
      expect(manager.user_id).to eq(user.id)
      expect(developer.user_id).to eq(user.id)
    end

    it "does not allow to rewrite user id of idea" do
      idea.user_id = other_user.id
      idea.save
      expect(idea.errors.messages.values.flatten).to include("user_id of project does not match ideas user_id.")
      expect(idea.reload.user_id).to_not eq(other_user.id)
    end

    it "does not allow to rewrite user id of idea with random id" do
      idea.user_id = 42
      idea.save
      expect(idea.errors.messages.values.flatten).to include("user_id of project does not match ideas user_id.")
      expect(idea.reload.user_id).to_not eq(42)
    end

    it "does not allow to rewrite project id of idea" do
      idea.project_id = other_project.id
      idea.save
      expect(idea.errors.messages.values.flatten).to include("user_id of project does not match ideas user_id.")
      expect(idea.reload.user_id).to_not eq(other_project.id)
    end

    it "does not allow to rewrite user id of issue" do
      issue.user_id = other_user.id
      issue.save
      expect(issue.errors.messages.values.flatten).to include("user_id of project does not match issues user_id.")
      expect(issue.reload.user_id).to_not eq(other_user.id)
    end

    it "does not allow to rewrite project id of issue" do
      issue.project_id = other_project.id
      issue.save
      expect(issue.errors.messages.values.flatten).to include("user_id of project does not match issues user_id.")
      expect(issue.reload.user_id).to_not eq(other_project.id)
    end

    it "does not allow to rewrite user id of comment" do
      comment.user_id = other_user.id
      comment.save
      expect(comment.errors.messages.values.flatten).to include("user_id of issue does not match comments user_id.")
      expect(comment.reload.user_id).to_not eq(other_user.id)
    end

    it "does not allow to rewrite issue id of comment" do
      comment.issue_id = other_issue.id
      comment.save
      expect(comment.errors.messages.values.flatten).to include("user_id of issue does not match comments user_id.")
      expect(comment.reload.user_id).to_not eq(other_issue.id)
    end

    it "does allow to rewrite user id of project" do
      project.user_id = other_user.id
      project.save
      expect(project.errors).to be_empty
      expect(project.reload.user_id).to eq(other_user.id)
    end

    it "does not allow to rewrite user id of developer" do
      developer.user_id = other_user.id
      developer.save
      expect(developer.errors.messages.values.flatten).to include("user_id of boss does not match developers user_id.")
      expect(developer.reload.user_id).to_not eq(other_user.id)
    end

    it "does not allow to rewrite boss id of developer" do
      developer.custom_boss_id = other_manager.id
      developer.save
      expect(developer.errors.messages.values.flatten).to include("user_id of boss does not match developers user_id.")
      expect(developer.reload.custom_boss_id).to_not eq(other_manager.id)
    end

  end
end
