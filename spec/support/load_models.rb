require "active_record"

class User < ActiveRecord::Base
  has_many :projects
  has_many :ideas
  has_many :managers
  has_many :developers
  has_many :comments
  has_many :issues
  has_many :ideas
end

class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :member
  has_many :ideas
  has_many :issues
end

class Idea < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
end

class Issue < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user
  belongs_to :member
end

class Dummy < ActiveRecord::Base
end

class Member < ActiveRecord::Base
  belongs_to :user
  has_many :projects
  has_many :comments
end

class Manager < Member
  has_many :developers
end

class Developer < Member
  belongs_to :boss, class_name: "Manager", foreign_key: :custom_boss_id
end
