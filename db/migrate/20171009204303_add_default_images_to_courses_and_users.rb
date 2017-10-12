class AddDefaultImagesToCoursesAndUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :image, :string, default: "user-default.jpg"
    change_column :courses, :image, :string, default: "course-default.jpg"
  end
end
