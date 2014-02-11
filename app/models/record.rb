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

	def self.import(file, sensor)
		spreadsheet = open_spreadsheet(file)
		header = spreadsheet.row(1)
		puts "--------------"
		puts header
		puts "--------------"
		(2..spreadsheet.last_row).each do |i|
			row = Hash[[header, spreadsheet.row(i)].transpose]
			record = find_by_id(row["id"]) || new
			puts "--------------"
			puts row.to_hash
			puts "--------------"
			record.attributes = row.to_hash
			record.sensor = sensor
			record.save!
		end
	end

	def self.open_spreadsheet(file)
		case File.extname(file.original_filename)
		when ".csv" then Roo::CSV.new(file.path)
		when ".xls" then Roo::Excel.new(file.path)
		when ".xlsx" then Roo::Excelx.new(file.path)
		else raise "Unknown file type: #{file.original_filename}"
		end
	end
end
