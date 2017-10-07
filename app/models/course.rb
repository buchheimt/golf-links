class Course < ApplicationRecord

  validates :name, presence: true

  has_many :tee_times
  has_many :user_tee_times, through: :tee_times
  has_many :users, through: :user_tee_times

  def active_tee_times
    TeeTime.course_date_sort(self)
  end

end
