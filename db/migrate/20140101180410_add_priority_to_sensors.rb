class AddPriorityToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :priority, :integer
  end
end
