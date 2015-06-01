class CreateSensorAccesses < ActiveRecord::Migration
  def change
    create_table :sensor_accesses do |t|
      t.integer :sensor_id, index: true
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end
