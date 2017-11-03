class CourseSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :par, :length, :price, :description, :image
  has_many :tee_times
end
