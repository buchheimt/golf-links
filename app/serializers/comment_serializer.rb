class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at_formatted
  belongs_to :user
end
