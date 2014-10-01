require 'spec_helper'

describe ForeignKeyValidation::ModelExtension do

  # NOTE: it's important to not create the objects through relation (user.projects.create...)
  #       it looks like active_record is caching the classes - but we need to test different class configs

  let(:user) { User.create }
  let(:other_user) { User.create }

  context "without calling validation" do

    let(:project) { Project.create user: user }
    let(:idea) { Idea.create user: user, project: project }
    let(:issue) { Issue.create user: user, project: project }
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

    it "allow to rewrite user id of idea with random id" do
      idea.user_id = 42
      idea.save
      idea.reload
      expect(idea.user_id).to eq(42)
    end

    it "allow to rewrite user id of idea" do
      idea.user_id = other_user.id
      idea.save
      idea.reload
      expect(idea.user_id).to eq(other_user.id)
    end

    it "allow to rewrite user id of project" do
      project.user_id = other_user.id
      project.save
      project.reload
      expect(project.user_id).to eq(other_user.id)
    end

    it "allow to rewrite user id of issue" do
      issue.user_id = other_user.id
      issue.save
      issue.reload
      expect(issue.user_id).to eq(other_user.id)
    end

    it "allow to rewrite user id of comment" do
      comment.user_id = other_user.id
      comment.save
      comment.reload
      expect(comment.user_id).to eq(other_user.id)
    end

    it "allow to rewrite user id of developer" do
      developer.user_id = other_user.id
      developer.save
      developer.reload
      expect(developer.user_id).to eq(other_user.id)
    end

    it "allow to rewrite boss id of developer" do
      developer.custom_boss_id = other_user.id
      developer.save
      developer.reload
      expect(developer.custom_boss_id).to eq(other_user.id)
    end

  end


end
