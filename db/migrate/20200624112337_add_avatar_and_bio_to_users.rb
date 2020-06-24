class AddAvatarAndBioToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :avatar, :string
    add_column :users, :bio, :text
  end
end
