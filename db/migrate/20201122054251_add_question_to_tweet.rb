class AddQuestionToTweet < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :question, :string
  end
end
