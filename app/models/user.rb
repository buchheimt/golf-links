class User < ApplicationRecord

  enum role: [:user, :admin]

  has_secure_password
  validates :username, uniqueness: true, presence: true
  validates :username, format: {with: /\A[\w ]+\z/, message: "username can only contain letters, numbers, and underscores"}
  validates :email, uniqueness: true, presence: true
  validates :email, format: {with: /.+@.+\..+/, message: "invalid email format"}
  validates :password, length: {minimum: 6}, presence: true, confirmation: true, on: :create
  validates :password, length: {minimum: 6}, allow_nil: true, on: :update
  validates_inclusion_of :pace, in: 1..10, allow_nil: true
  validates_inclusion_of :experience, in: 1..10, allow_nil: true

  has_many :user_tee_times
  has_many :tee_times, through: :user_tee_times
  has_many :courses, through: :tee_times

  def favorite_course
    rank_hash = TeeTime.joins(:user_tee_times).joins(:users).where("user_tee_times.user_id = ?", self.id).distinct.group("tee_times.course_id").count
    Course.find_by_id(rank_hash.max_by{|k,v| v}[0])
  end

  def active_tee_times
    TeeTime.user_date_sort(self)
  end

end
