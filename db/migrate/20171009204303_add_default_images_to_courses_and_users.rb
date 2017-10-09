class AddDefaultImagesToCoursesAndUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :image, :string, default: "golf-ball.jpg"
    change_column :courses, :image, :string, default: "course-bg.jpg"
  end
end
