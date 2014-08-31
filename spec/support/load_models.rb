require "active_record"

class User < ActiveRecord::Base
  has_many :projects
  has_many :ideas
end

class Project < ActiveRecord::Base
  belongs_to :user
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
end

class Dummy < ActiveRecord::Base
end
