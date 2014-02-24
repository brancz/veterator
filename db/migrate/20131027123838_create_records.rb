class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.decimal :value
      t.integer :sensor_id

      t.timestamps
    end

		add_index :records, :created_at
  end
end
