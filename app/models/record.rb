class Record < ActiveRecord::Base
  belongs_to :sensor

  validates :value,
    presence: true

  validates :sensor_id,
    presence: true

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      columns = ["created_at", "value"]
      csv << columns
      all.each do |record|
        csv << record.attributes.values_at(*columns)
      end
    end
  end
end
