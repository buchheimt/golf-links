class Comment < ApplicationRecord

  belongs_to :tee_time
  belongs_to :user

  validates :content, presence: true

end
