class AddDefaultGuestCountToUserTeeTime < ActiveRecord::Migration[5.1]
  def change
    change_column :user_tee_times, :guest_count, :integer, default: 0
  end
end
