class TeeTime < ApplicationRecord

  belongs_to :course
  has_many :user_tee_times
  has_many :users, through: :user_tee_times
  accepts_nested_attributes_for :course

  def course_attributes=(course_attributes)
    #binding.pry
    self.build_course(course_attributes) unless self.course
    #binding.pry
  end

end
