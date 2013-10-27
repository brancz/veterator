class Unit < ActiveRecord::Base
  belongs_to :type

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
