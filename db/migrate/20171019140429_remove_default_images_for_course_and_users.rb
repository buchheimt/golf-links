class RemoveDefaultImagesForCourseAndUsers < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:users, :image, nil)
    change_column_default(:courses, :image, nil)
  end
end
