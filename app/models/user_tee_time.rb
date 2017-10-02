class UserTeeTime < ApplicationRecord

  belongs_to :user
  belongs_to :tee_time
  delegate :course, to: :tee_time

end
