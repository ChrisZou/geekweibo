class AddParentCommentIdToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :parent_comment_id, :uuid
  end
end
