class UserTeeTime < ApplicationRecord

  belongs_to :user
  belongs_to :tee_time
  delegate :course, to: :tee_time

  validates :guest_count, numericality: true
  validates_inclusion_of :guest_count, in: 0..3, allow_nil: true

end
