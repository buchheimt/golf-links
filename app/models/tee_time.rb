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

  def group_size
    self.users.size
  end

  def avg_pace
    self.users.inject(0) {|sum, user| sum += user.pace} / group_size.to_f
  end

  def avg_experience
    self.users.inject(0) {|sum, user| sum += user.experience} / group_size.to_f
  end

  def group_description
    "Group Size: #{group_size}/4 | Avg. Pace: #{avg_pace} | Avg. Experience: #{avg_experience}"
  end

  def self.date_sort
    all.order(time: :asc)
  end

  def self.user_date_sort(user)
    joins(:user_tee_times).joins(:users).where("user_tee_times.user_id = ?", user.id).order(time: :asc)
  end

  def self.course_date_sort(course)
    where(course_id: course.id).order(time: :asc)
  end

end
