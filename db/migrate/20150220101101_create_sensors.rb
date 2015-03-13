class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.string :title
      t.string :description
      t.integer :chart_type, default: 0
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :sensors, :users
  end
end
