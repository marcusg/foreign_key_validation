require 'spec_helper'

class User < ActiveRecord::Base
  has_many :projects
  has_many :ideas
end

class Project < ActiveRecord::Base
  belongs_to :user
  has_many :ideas
  validates_presence_of :user_id, presence: true
end

class Idea < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  validates_presence_of :user_id, :project_id, presence: true
end

describe "Behaviour without validate_foreign_keys" do

  let!(:user) { User.create }
  let!(:project) { user.projects.create }
  let!(:idea) { project.ideas.create user: user }

  it "uses same user ids by default" do
    expect(project.user_id).to eq(user.id)
    expect(user.id).to eq(user.id)
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

  before do
    Idea.class_eval do
      validate_foreign_keys
    end
  end

  let!(:user) { User.create }
  let!(:project) { user.projects.create }
  let!(:idea) { project.ideas.create user: user }

  it "uses same user ids by default" do
    expect(project.user_id).to eq(user.id)
    expect(user.id).to eq(user.id)
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