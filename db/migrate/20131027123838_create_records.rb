class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.decimal :value
      t.string :sensor_id

      t.timestamps
    end
  end
end
