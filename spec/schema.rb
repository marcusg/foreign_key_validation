ActiveRecord::Schema.define(:version => 20130730063732) do

  create_table "users", :force => true do |t|
  end

  create_table "projects", :force => true do |t|
    t.integer   "user_id"
  end

  create_table "ideas", :force => true do |t|
    t.integer   "user_id"
    t.integer   "project_id"
  end

end