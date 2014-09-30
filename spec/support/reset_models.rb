ActiveRecord::Base.descendants.each do |klass|
  Object.send(:remove_const, klass.name.to_sym) if Object.constants.include?(klass.name.to_sym)
end
