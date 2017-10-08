class User < ApplicationRecord

  enum role: [:user, :owner, :admin]

  has_secure_password
  validates :username, uniqueness: true, presence: true
  validates :username, format: {with: /\A[\w ]+\z/, message: "username can only contain letters, numbers, and underscores"}
  validates :email, uniqueness: true, presence: true
  validates :email, format: {with: /.+@.+\..+/, message: "invalid email format"}
  validates :password, length: {minimum: 6}, presence: true, confirmation: true
  validates_inclusion_of :pace, in: 1..10, allow_nil: true
  validates_inclusion_of :experience, in: 1..10, allow_nil: true

  has_many :user_tee_times
  has_many :tee_times, through: :user_tee_times
  has_many :courses, through: :tee_times

  def favorite_course
    rank_hash = TeeTime.joins(:user_tee_times).joins(:users).where("user_tee_times.user_id = ?", self.id).group("tee_times.course_id").count
    Course.find_by_id(rank_hash.max_by{|k,v| v})
  end

end
TeeTime.joins(:user_tee_times).joins(:users).where("user_tee_times.user_id = ?", User.first.id).group("tee_times.course_id").count
