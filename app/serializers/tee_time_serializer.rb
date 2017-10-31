class TeeTimeSerializer < ActiveModel::Serializer
  attributes :id, :time
  belongs_to :course
end
