class Unit < ActiveRecord::Base
  has_many :users

  validates :name,
    presence: true,
    :uniqueness => {
      :case_sensitive => true
    }

  validates :symbol,
    presence: true

  validates :type_id,
    presence: true
end
