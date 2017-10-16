class User < ApplicationRecord

  enum role: [:user, :admin]

  has_many :user_tee_times
  has_many :tee_times, through: :user_tee_times
  has_many :courses, through: :tee_times

  has_secure_password
  validates :username, uniqueness: true, presence: true
  validates :username, format: {with: /\A[\w ]+\z/, message: "username can only contain letters, numbers, and underscores"}
  validates :email, uniqueness: true, presence: true
  validates :email, format: {with: /.+@.+\..+/, message: "invalid email format"}
  validates :password, length: {minimum: 6}, presence: true, confirmation: true, on: :create
  validates :password, length: {minimum: 6}, allow_nil: true, on: :update
  validates_inclusion_of :pace, in: 1..10, allow_nil: true
  validates_inclusion_of :experience, in: 1..10, allow_nil: true

  def favorite_course
    rank_hash = TeeTime.joins(:user_tee_times).joins(:users).where("user_tee_times.user_id = ?", self.id).distinct.group("tee_times.course_id").count
    Course.find_by_id(rank_hash.max_by{|k,v| v}[0])
  end

  def active_tee_times
    TeeTime.joins(:user_tee_times).joins(:users).where("user_tee_times.user_id = ? AND tee_times.time > ?", self.id, Time.now).order(time: :asc).uniq
  end

  def has_guests?(tee_time)
    user_tee_time = UserTeeTime.find_by(user_id: self.id, tee_time_id: tee_time.id)
    user_tee_time.guest_count > 0
  end

  def connect_from_omniauth(auth)
    self.uid = auth['uid']
    self.image = auth['info']['image'] + "?type=large"
    self.save
  end

  def self.new_from_omniauth(auth)
    user = self.find_or_create_by(uid: auth['uid']) do |u|
      u.username = auth['info']['name'].split(" ")[0].capitalize + auth[:info][:name].split(" ")[1][0] + auth[:uid][0...2]
      u.email = auth['info']['email']
      u.uid = auth['uid']
      u.password = SecureRandom.hex
      u.password_confirmation = u.password
      u.image = auth['info']['image'] + "?type=large"
      u.save
    end
    user
  end

end
