class TeeTime < ApplicationRecord

  belongs_to :course
  has_many :user_tee_times
  has_many :users, through: :user_tee_times
  validates :time, presence: true
  validate :valid_date, on: :create
  accepts_nested_attributes_for :course

  def valid_date
    errors.add(:time, "selected can't be a previous day") unless !time.nil? && time.to_date >= Time.now.to_date
  end

  def course_attributes=(course_attributes)
    self.build_course(course_attributes) unless self.course
  end

  def user_tee_times_attributes=(user_tee_times_attributes)
    user_tee_time = self.user_tee_times.build
    user_tee_time.user_id = user_tee_times_attributes['0'][:user_id]
    guest_count = user_tee_times_attributes['0'][:guest_count]
    user_tee_time.guest_count = guest_count unless guest_count.empty?
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
    (self.users.inject(0) {|sum, user| sum += user.pace} / users.size.to_f).round(1)
  end

  def avg_experience
    (self.users.inject(0) {|sum, user| sum += user.experience} / users.size.to_f).round(1)
  end

  def group_description
    "<strong>Size:</strong> #{group_size}/4 | <strong>Avg. Pace:</strong> #{avg_pace} | <strong>Avg. Experience:</strong> #{avg_experience}".html_safe
  end

  def available?
    self.group_size < 4 && self.time >= Time.now.to_date
  end

  def joinable?(user)
    !!user && !self.users.include?(user) && available?
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
