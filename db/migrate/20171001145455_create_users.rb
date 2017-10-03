class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.integer :pace
      t.integer :experience
      t.string :user_id
      t.string :image

      t.timestamps
    end
  end
end
