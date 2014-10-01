require 'spec_helper'

describe ForeignKeyValidation::ModelExtension do

  let(:user) { User.create }
  let(:other_user) { User.create }

  context "with calling validation with custom attributes hash" do
    before do
      Comment.class_eval do
        validate_foreign_keys on: :user, with: :issue # member is not in list - should be editable
      end
    end

    let(:project) { Project.create user: user }
    let(:other_project) { Project.create user: other_user }
    let(:issue) { Issue.create user: user, project: project }
    let(:other_issue) { Issue.create user: other_user, project: other_project }
    let(:comment) { Comment.create user: user, issue: issue }
    let(:manager) { Manager.create user: user }
    let(:other_manager) { Manager.create user: User.create }

    it "uses same user ids by default" do
      expect(project.user_id).to eq(user.id)
      expect(issue.user_id).to eq(user.id)
      expect(comment.user_id).to eq(user.id)
      expect(manager.user_id).to eq(user.id)
    end

    it "does not allow to rewrite issue id of comment" do
      comment.issue_id = other_issue.id
      comment.save
      expect(comment.errors.messages.values.flatten).to include("user_id of issue does not match comments user_id.")
      expect(comment.reload.issue_id).to_not eq(other_issue.id)
    end

    # NOTE: this is possible here because Issue model is not configured to check ids
    #       comment model can only check id against issue model if it is present
    it "does allow to rewrite issue id of comment with random id" do
      comment.issue_id = 42
      comment.save
      comment.reload
      expect(comment.issue_id).to eq(42)
    end

    it "allow to rewrite member id of comment" do
      comment.member_id = other_manager.id
      comment.save
      comment.reload
      expect(comment.member_id).to eq(other_manager.id)
    end

    it "allow to rewrite user id of issue" do
      issue.user_id = other_user.id
      issue.save
      issue.reload
      expect(issue.user_id).to eq(other_user.id)
    end

    it "allow to rewrite user id of manager" do
      manager.user_id = other_user.id
      manager.save
      manager.reload
      expect(manager.user_id).to eq(other_user.id)
    end

  end

end
