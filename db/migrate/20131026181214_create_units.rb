class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name
      t.string :symbol
      t.integer :type_id

      t.timestamps
    end
  end
end
