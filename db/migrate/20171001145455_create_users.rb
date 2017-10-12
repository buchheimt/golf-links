class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.integer :pace
      t.integer :experience
      t.string :uid
      t.string :image
      t.integer :role

      t.timestamps
    end
  end
end
