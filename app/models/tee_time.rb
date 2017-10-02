class TeeTime < ApplicationRecord

  belongs_to :course
  has_many :user_tee_times
  has_many :users, through: :user_tee_times

end
