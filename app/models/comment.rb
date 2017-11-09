class Comment < ApplicationRecord

  belongs_to :tee_time
  belongs_to :user

  validates :content, presence: true

  def created_at_formatted
    self.created_at.strftime("%l:%M %p CT %m/%d/%Y")
  end

end
