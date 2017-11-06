class UserTeeTimeSerializer < ActiveModel::Serializer

  attributes :id, :guest_count
  belongs_to :user

end
