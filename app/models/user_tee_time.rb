class UserTeeTime < ApplicationRecord

  belongs_to :user
  belongs_to :tee_time
  delegate :course, to: :tee_time

  validates :guest_count, numericality: true
  validates_inclusion_of :guest_count, in: 0..3, allow_nil: true

  def add_guest
    self.guest_count += 1 if tee_time.available? && tee_time.users.include?(user)
  end

  def remove_guest
    self.guest_count -= 1 if self.guest_count >= 1 && tee_time.users.include?(user)
  end

end
