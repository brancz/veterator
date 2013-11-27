class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable, :lockable, :timeoutable,
    :authentication_keys => [:login]

  has_many :sensors
  has_many :authentication_tokens

  validates :username,
    :uniqueness => {
      :case_sensitive => true
  }

  attr_accessor :login

	def generate_new_token!
		new_token = SecureRandom.hex
		self.token = Digest::SHA1::hexdigest(new_token)
		self.token_valid_until = 2.weeks.from_now
		new_token
	end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

end
