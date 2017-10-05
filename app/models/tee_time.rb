class TeeTime < ApplicationRecord

  belongs_to :course
  has_many :user_tee_times
  has_many :users, through: :user_tee_times
  validates :time, presence: true
  accepts_nested_attributes_for :course

  def course_attributes=(course_attributes)
    self.build_course(course_attributes) unless self.course
  end

  def add_user(user)
    if !self.users.include?(user) && self.user_tee_times.size <= 3
      self.user_tee_times.build(user_id: user.id)
      self.save
    end
  end

end
