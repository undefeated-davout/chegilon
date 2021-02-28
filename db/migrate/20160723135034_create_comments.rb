class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :item, index: true
      t.text :content
      t.string :image
      t.boolean :remove_image
      t.string :image_cache

      t.timestamps
    end
    add_index :comments, [:created_at]
    add_index :comments, [:user_id, :created_at]
    add_index :comments, [:user_id, :item_id, :created_at]
  end
end
