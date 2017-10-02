class CreateUserTeeTimes < ActiveRecord::Migration[5.1]
  def change
    create_table :user_tee_times do |t|
      t.integer :user_id
      t.integer :tee_time_id

      t.timestamps
    end
  end
end
