class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :pace, :experience, :get_image
end
