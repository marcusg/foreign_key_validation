require 'spec_helper'

describe ForeignKeyValidation::ModelExtension do

  context "Without calling validation" do
    # NOTE: it's important here to not create the object through relation (user.projects.create...)
    let!(:user) { User.create }
    let!(:project) { Project.create user: user }
    let!(:idea) { Idea.create user: user, project: project }

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

  end

  context "With calling validation" do
    before do
      Idea.instance_eval do
        validate_foreign_keys
      end
    end
    # NOTE: it's important here to not create the object through relation (user.projects.create...)
    let!(:user) { User.create }
    let!(:project) { Project.create user: user }
    let!(:idea) { Idea.create user: user, project: project }

    it "uses same user ids by default" do
      expect(project.user_id).to eq(user.id)
      expect(idea.user_id).to eq(user.id)
    end

    it "does not allow to rewrite user id of idea" do
      idea.user_id = 42
      idea.save
      expect(idea.errors.messages.values.flatten).to include("user_id of project does not match ideas user_id")
      expect(idea.reload.user_id).to_not eq(42)
    end

    it "does allow to rewrite user id of project" do
      project.user_id = 42
      project.save
      expect(project.errors).to be_empty
      expect(project.reload.user_id).to eq(42)
    end

  end
end
