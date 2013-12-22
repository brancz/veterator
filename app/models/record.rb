class Record < ActiveRecord::Base
  belongs_to :sensor

  validates :value,
    presence: true

  validates :sensor_id,
    presence: true

  def self.to_csv(options = {})
    require 'csv'
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |record|
        csv << record.attributes.values_at(*column_names)
      end
    end
  end
end
