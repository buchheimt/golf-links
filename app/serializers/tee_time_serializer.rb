class TeeTimeSerializer < ActiveModel::Serializer

  attributes :id, :time, :active, :time_formatted, :group_size, :avg_pace, :avg_experience, :available?, :user_tee_times
  belongs_to :course
  has_many :user_tee_times
end
