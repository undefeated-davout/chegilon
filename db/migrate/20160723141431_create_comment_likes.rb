class CreateCommentLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :comment_likes do |t|
      t.references :comment, index: true
      t.references :user, index: true

      t.timestamps
    end
    add_index :comment_likes, [:comment_id, :user_id], unique: true
  end
end
