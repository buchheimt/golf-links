class CreateTeeTimes < ActiveRecord::Migration[5.1]
  def change
    create_table :tee_times do |t|
      t.integer :course_id
      t.datetime :time
      t.string :status

      t.timestamps
    end
  end
end
