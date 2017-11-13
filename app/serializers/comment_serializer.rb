class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :timestamp, :status
  belongs_to :user
end
