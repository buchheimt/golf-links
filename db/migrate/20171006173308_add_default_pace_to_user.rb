class AddDefaultPaceToUser < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :pace, :integer, default: 5
  end
end
