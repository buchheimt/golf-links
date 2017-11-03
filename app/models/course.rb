class Course < ApplicationRecord

  has_many :tee_times
  has_many :user_tee_times, through: :tee_times
  has_many :users, through: :user_tee_times

  validates :name, presence: true
  validates :location, presence: true
  validates :par, numericality: {only_integer: true, greater_than_or_equal_to: 54}, allow_nil: true
  validates :length, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true
  validates :price, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true
  validate :valid_image_url

  def valid_image_url
    unless self.image.nil? || self.image.match(/^https?:\/\/|^\/\//i) || self.image.empty? || self.image == 'course-default.jpg'
      errors.add(:image, "must be a valid URL. Leave blank for default")
    end
  end

  def get_image
    self.image && !self.image.empty? ? self.image : 'course-default.jpg'
  end

  def active_tee_times
    TeeTime.active_sort.where(course_id: self.id)
  end

  def self.most_popular
    rank_hash = joins(:tee_times).group("courses.id").count
    Course.find_by_id(rank_hash.max_by{|k,v| v}[0])
  end

  def self.find_next_course(id)
    next_course = where("id > ?", id).order(id: :asc).limit(1)
    next_course.empty? ? self.first : next_course.first
  end

  def self.find_prev_course(id)
    prev_course = where("id < ?", id).order(id: :desc).limit(1)
    prev_course.empty? ? self.last : prev_course.first
  end

end
