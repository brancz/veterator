class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.decimal :value
      t.references :sensor, index: true

      t.timestamps null: false
    end
    add_foreign_key :records, :sensors
  end
end
