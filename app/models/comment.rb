class Comment < ApplicationRecord

  belongs_to :tee_time
  belongs_to :user

end
