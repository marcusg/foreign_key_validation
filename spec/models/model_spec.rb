require 'spec_helper'

describe ForeignKeyValidation::ModelExtension do

  # NOTE: it's important to not create the objects through relation (user.projects.create...)
  #       it looks like active_record is caching the classes - but we need to test different class configs

  context "without calling validation" do

    let(:user) { User.create }
    let(:project) { Project.create user: user }
    let(:idea) { Idea.create user: user, project: project }
    let(:issue) { Issue.create user: user, project: project }
    let(:comment) { Comment.create user: user, issue: issue }
    # sti model
    let(:manager) { Manager.create user: user }
    let(:developer) { Developer.create user: user, boss: manager }

    it "uses same user ids by default" do
      expect(project.user_id).to eq(user.id)
      expect(idea.user_id).to eq(user.id)
    end

    it "allow to rewrite user id of idea" do
      idea.user_id = 42
      idea.save
      idea.reload
      expect(idea.user_id).to eq(42)
    end

    it "allow to rewrite user id of project" do
      project.user_id = 42
      project.save
      project.reload
      expect(project.user_id).to eq(42)
    end

    it "allow to rewrite user id of issue" do
      issue.user_id = 42
      issue.save
      issue.reload
      expect(issue.user_id).to eq(42)
    end

    it "allow to rewrite user id of comment" do
      comment.user_id = 42
      comment.save
      comment.reload
      expect(comment.user_id).to eq(42)
    end

    it "allow to rewrite user id of developer" do
      developer.user_id = 42
      developer.save
      developer.reload
      expect(developer.user_id).to eq(42)
    end

  end

  context "with calling validation" do
    before do
      Idea.send :validate_foreign_keys
      Project.send :validate_foreign_keys
      Issue.send :validate_foreign_keys
      Comment.send :validate_foreign_keys
      Member.send :validate_foreign_keys # sti model
    end

    let(:user) { User.create }
    let(:project) { Project.create user: user }
    let(:idea) { Idea.create user: user, project: project }
    let(:issue) { Issue.create user: user, project: project }
    let(:comment) { Comment.create user: user, issue: issue }
    # sti model
    let(:manager) { Manager.create user: user }
    let(:developer) { Developer.create user: user, boss: manager }

    it "uses same user ids by default" do
      expect(project.user_id).to eq(user.id)
      expect(idea.user_id).to eq(user.id)
    end

    it "does not allow to rewrite user id of idea" do
      idea.user_id = 42
      idea.save
      expect(idea.errors.messages.values.flatten).to include("user_id of project does not match ideas user_id.")
      expect(idea.reload.user_id).to_not eq(42)
    end

    it "does not allow to rewrite user id of issue" do
      issue.user_id = 42
      issue.save
      expect(issue.errors.messages.values.flatten).to include("user_id of project does not match issues user_id.")
      expect(issue.reload.user_id).to_not eq(42)
    end

    it "does not allow to rewrite user id of comment" do
      comment.user_id = 42
      comment.save
      expect(comment.errors.messages.values.flatten).to include("user_id of issue does not match comments user_id.")
      expect(comment.reload.user_id).to_not eq(42)
    end

    it "does allow to rewrite user id of project" do
      project.user_id = 42
      project.save
      expect(project.errors).to be_empty
      expect(project.reload.user_id).to eq(42)
    end

    it "does not allow to rewrite user id of developer" do
      developer.user_id = 42
      developer.save
      expect(developer.errors.messages.values.flatten).to include("user_id of boss does not match developers user_id.")
      expect(developer.reload.user_id).to_not eq(42)
    end

    it "does not allow to call private validate_foreign_key method" do
      expect{issue.validate_foreign_key("test", "unrat")}.to raise_exception(/private method `validate_foreign_key' called/)
    end

    it "does not allow to call private validate_foreign_keys_on_* methods" do
      expect{issue.validate_foreign_keys_on_user}.to raise_exception(/private method `validate_foreign_keys_on_user' called/)
    end

  end

  context "with calling validation with attributes hash" do
    before do
      Idea.class_eval do
        validate_foreign_keys on: :user, with: :project
      end
    end

    let(:user) { User.create }
    let(:project) { Project.create user: user }
    let(:idea) { Idea.create user: user, project: project }
    let(:issue) { Issue.create user: user, project: project }
    let(:comment) { Comment.create user: user, issue: issue }

    it "uses same user ids by default" do
      expect(project.user_id).to eq(user.id)
      expect(idea.user_id).to eq(user.id)
    end

    it "does not allow to rewrite user id of idea" do
      idea.user_id = 42
      idea.save
      expect(idea.errors.messages.values.flatten).to include("user_id of project does not match ideas user_id.")
      expect(idea.reload.user_id).to_not eq(42)
    end

    it "allow to rewrite user id of project" do
      project.user_id = 42
      project.save
      project.reload
      expect(project.user_id).to eq(42)
    end

    it "allow to rewrite user id of issue" do
      issue.user_id = 42
      issue.save
      issue.reload
      expect(issue.user_id).to eq(42)
    end

    it "allow to rewrite user id of comment" do
      comment.user_id = 42
      comment.save
      comment.reload
      expect(comment.user_id).to eq(42)
    end

  end

  context "with calling validation and wrong attributes hash" do

    it "raises error due to wrong :on key" do
      expect{Idea.class_eval { validate_foreign_keys on: :not_existing }}.to raise_error("No foreign key for relation not_existing on ideas table!")
    end

    it "raises error due to wrong :with key" do
      expect{Idea.class_eval { validate_foreign_keys with: :not_existing }}.to raise_error('Unknown relation in ["not_existing"]!')
    end

  end

  context "with calling validation and missing relations" do

    it "raises error due to wrong :on key" do
      expect{Dummy.class_eval { validate_foreign_keys }}.to raise_error("Can't find any belongs_to relations for Dummy class. Put validation call below association definitions!")
    end

  end


  context "with calling validation and missing foreign key on self" do

    before do
      Issue.class_eval do
        validate_foreign_keys
      end
    end

    let(:user) { User.create }
    let(:project) { Project.create user: user }
    let(:issue) { Issue.create project: project }

    it "does not allow to rewrite user id of issue" do
      issue.user_id = 42
      issue.save
      expect(issue.errors.messages.values.flatten).to include("user_id of project does not match issues user_id.")
      expect(issue.reload.user_id).to_not eq(42)
    end

  end

  context "with calling validation and missing foreign key on relation" do

    before do
      Issue.class_eval do
        validate_foreign_keys
      end
    end

    let(:user) { User.create }
    let(:project) { Project.create }
    let(:issue) { Issue.create project: project, user: user }

    it "allow to rewrite user id of issue" do
      issue.user_id = 42
      issue.save
      issue.reload
      expect(issue.user_id).to eq(42)
    end

  end

end
