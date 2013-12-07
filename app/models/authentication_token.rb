class AuthenticationToken < ActiveRecord::Base
  belongs_to :user

	def renew
		self.update(valid_until: 2.days.from_now)
	end
end
