class CreateTagFollows < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_follows do |t|
      t.references :tag, index: true
      t.references :user, index: true

      t.timestamps
    end
    add_index :tag_follows, [:tag_id, :user_id], unique: true
  end
end
