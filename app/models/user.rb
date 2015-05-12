class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_and_belongs_to_many :sensors

  def create_new_authentication_token
    raw_token, self.authentication_token = User.generate_safe_token
    self.save
    raw_token
  end

  class << self
    def generate_safe_token
      token = nil
      token_hash = nil
      loop do
        token = Devise.friendly_token
        token_hash = hmac token
        break if find_by(authentication_token: token_hash).nil?
      end
      [token, token_hash]
    end

    def find_by_raw_token(raw_token)
      find_by authentication_token: hmac(raw_token)
    end

    def hmac(string)
      encode OpenSSL::HMAC.digest(digest, Devise.secret_key, string)
    end

    def encode(plain_text)
      Base64.encode64(plain_text).encode('utf-8')
    end

    def digest
      OpenSSL::Digest::SHA256.new
    end
  end
end
