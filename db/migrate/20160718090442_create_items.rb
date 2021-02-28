class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :title
      t.string :tag_list_entry
      t.text :content
      t.text :update_comment
      t.references :create_user, index: true
      t.references :update_user, index: true
      t.integer :lock_version, null: false, default: 0
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :items, [:create_user_id, :update_user_id, :updated_at], :name => 'item_by_create_update_user'
  end
end
