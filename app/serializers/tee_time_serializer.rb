class TeeTimeSerializer < ActiveModel::Serializer
  attributes :id, :active, :time_formatted, :group_size, :avg_pace, :avg_experience, :available?, :userIds
  belongs_to :course, serializer: TeeTimeCourseSerializer
end
