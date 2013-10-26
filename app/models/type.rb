class Type < ActiveRecord::Base
  has_many :units

  validates :name,
    presence: true,
    :uniqueness => {
      :case_sensitive => true
    }
end
