class TeeTime < ApplicationRecord

  belongs_to :course
  has_many :user_tee_times
  has_many :users, through: :user_tee_times
  validates :time, presence: true
  validate :valid_date
  accepts_nested_attributes_for :course

  def valid_date
    errors.add(:time, "Selected can't be in the past") unless time.nil? || time > Time.now
  end

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
    (self.users.inject(0) {|sum, user| sum += user.pace} / group_size.to_f).round(1)
  end

  def avg_experience
    (self.users.inject(0) {|sum, user| sum += user.experience} / group_size.to_f).round(1)
  end

  def group_description
    "<strong>Size:</strong> #{group_size}/4 | <strong>Avg. Pace:</strong> #{avg_pace} | <strong>Avg. Experience:</strong> #{avg_experience}".html_safe
  end

  def joinable?(user)
    !self.users.include?(user) && self.users.size < 4 && !!user
  end

  def self.date_sort
    where("time > ?", Time.now).order(time: :asc)
  end

  def self.user_date_sort(user)
    joins(:user_tee_times).joins(:users).where("user_tee_times.user_id = ?", user.id).where("time > ?", Time.now).order(time: :asc).uniq
  end

  def self.course_date_sort(course)
    where(course_id: course.id).where("time > ?", Time.now).order(time: :asc)
  end

end
