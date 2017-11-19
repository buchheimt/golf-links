class Comment < ApplicationRecord

  enum status: [:removed, :active]

  belongs_to :tee_time
  belongs_to :user

  validates :content, presence: true

  def timestamp
    self.created_at.in_time_zone('Central Time (US & Canada)').strftime("%l:%M %p CT %m/%d/%Y")
  end

  def wipe
    self.content = "[removed]"
    self.status = "removed"
    self.save
  end

  def self.for_tee_time_sorted(id)
    where("tee_time_id = ?", id).order("comments.created_at ASC")
  end

end
