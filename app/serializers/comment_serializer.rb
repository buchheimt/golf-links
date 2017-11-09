class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at_formatted, :status
  belongs_to :user
end
