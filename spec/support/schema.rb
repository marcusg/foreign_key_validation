ActiveRecord::Schema.define do
  self.verbose = false

  create_table "users", :force => true do |t|
  end

  create_table "projects", :force => true do |t|
    t.integer   "user_id"
  end

  create_table "ideas", :force => true do |t|
    t.integer   "user_id"
    t.integer   "project_id"
  end

  create_table "issues", :force => true do |t|
    t.integer   "user_id"
    t.integer   "project_id"
  end

  create_table "comments", :force => true do |t|
    t.integer   "user_id"
    t.integer   "issue_id"
  end

end
