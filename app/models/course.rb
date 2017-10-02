class Course < ApplicationRecord

  validates :name, presence: true

  has_many :tee_times
  has_many :user_tee_times, through: :tee_times
  has_many :users, through: :user_tee_times

end
