class Course < ApplicationRecord

  validates :name, presence: true
  validates :location, presence: true
  validates :par, numericality: {only_integer: true, greater_than_or_equal_to: 54}, allow_nil: true
  validates :length, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true
  validates :price, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true

  has_many :tee_times
  has_many :user_tee_times, through: :tee_times
  has_many :users, through: :user_tee_times

  def active_tee_times
    TeeTime.course_date_sort(self)
  end

end
