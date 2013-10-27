class AddUserIdToSensor < ActiveRecord::Migration
  def change
    add_column :sensors, :user_id, :integer
  end
end
