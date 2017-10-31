class TeeTimeSerializer < ActiveModel::Serializer

  attributes :id, :time_formatted, :group_size, :avg_pace, :avg_experience
  belongs_to :course

end
