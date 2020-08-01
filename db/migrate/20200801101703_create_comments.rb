class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :tweet, null: false, foreign_key: true, type: :uuid
      t.text :body

      t.timestamps
    end
  end
end
