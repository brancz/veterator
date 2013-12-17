class UserRole < ActiveRecord::Base
	has_one :user
	has_one :role
end
