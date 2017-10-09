class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.string :location
      t.integer :par
      t.integer :length
      t.integer :price
      t.string :image

      t.timestamps
    end
  end
end
