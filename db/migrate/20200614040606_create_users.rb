class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :nickname
      t.string :phone
      t.string :password_digest

      t.timestamps
    end
  end
end
