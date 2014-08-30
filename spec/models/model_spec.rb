require 'spec_helper'

describe "Behaviour without validate_foreign_keys" do

  before(:all) do
    # load "support/reset_models.rb"
    # load "support/models.rb"
  end

  let(:user) { User.create }
  let(:project) { user.projects.create }
  let(:idea) { project.ideas.create user: user }

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

describe "Behaviour with validate_foreign_keys" do

  before(:each) do
    # load "support/reset_models.rb"
    # load "support/models.rb"
    Idea.send :validate_foreign_keys
  end

  let(:user) { User.create }
  let(:project) { user.projects.create }
  let(:idea) { project.ideas.create user: user }

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
