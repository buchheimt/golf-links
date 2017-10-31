class TeeTime < ApplicationRecord

  belongs_to :course
  has_many :user_tee_times
  has_many :users, through: :user_tee_times
  has_many :comments

  validates :time, presence: true
  validate :valid_date, on: :create
  validate :no_conflicts, on: :create
  accepts_nested_attributes_for :course

  def valid_date
    errors.add(:time, "selected can't be a previous day") unless !time.nil? && time.to_date >= Time.now.to_date
  end

  def no_conflicts
    course_times = course.tee_times
    if !course_times.empty? && course_times.any? {|tt| tt.time == time && tt.id != nil}
      errors.add(:time, "is already scheduled at this course")
    end
    user_times = user_tee_times.first.user.tee_times
    if user_times && user_times.any? {|tt| tt.time == time && tt.id != nil && tt.id != self.id}
      errors.add(:time, "is already scheduled for this user")
    end
  end

  def course_attributes=(course_attributes)
    self.build_course(course_attributes) unless self.course
  end

  def user_tee_times_attributes=(user_tee_times_attributes)
    user_tee_time = self.user_tee_times.build
    user_tee_time.tee_time_id = self.id
    user_tee_time.user_id = user_tee_times_attributes['0'][:user_id]
    guest_count = user_tee_times_attributes['0'][:guest_count]
    user_tee_time.guest_count = guest_count unless guest_count.empty?
  end

  def time_formatted
    time.strftime("%A %b %e, %Y | %l:%M %p")
  end

  def add_user(user)
    if !self.users.include?(user) && self.user_tee_times.size <= 3
      self.user_tee_times.build(user_id: user.id)
      self.save
    end
  end

  def group_size
    self.users.size + self.user_tee_times.inject(0) {|sum, utt| sum += utt.guest_count}
  end

  def avg_pace
    (self.users.inject(0) {|sum, user| sum += user.pace} / users.size.to_f).round(1).to_s
  end

  def avg_experience
    (self.users.inject(0) {|sum, user| sum += user.experience} / users.size.to_f).round(1).to_s
  end

  def available?
    self.group_size < 4 && self.time >= Time.now.to_date
  end

  def joinable?(user)
    !!user && !self.users.include?(user) && available? && user.tee_times.none? {|tt| tt.time == time }
  end

  def self.active_sort
    where("time >= ?", Time.now.to_date).order(time: :asc)
  end

  def self.inactive_sort
    where("time < ?", Time.now.to_date).order(time: :asc)
  end

  def self.all_sort
    all.order(time: :asc)
  end

  def self.size_filter(sizes, status)
    self.send("#{status}_sort").select {|tt| sizes.include?(tt.users.size.to_s)}
  end

  def guests
    guests = []
    self.user_tee_times.each do |user_tee_time|
      user_tee_time.guest_count.times {guests << user_tee_time.user.username}
    end
    guests
  end

end
