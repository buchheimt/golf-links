class UserTeeTimeSerializer < ActiveModel::Serializer
  attributes :id, :guest_count
  belongs_to :user
  belongs_to :tee_time, serializer: UserTeeTimeTeeTimeSerializer
end
