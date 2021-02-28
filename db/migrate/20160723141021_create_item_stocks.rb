class CreateItemStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :item_stocks do |t|
      t.references :item, index: true
      t.references :user, index: true

      t.timestamps
    end
    add_index :item_stocks, [:item_id, :user_id], unique: true
  end
end
