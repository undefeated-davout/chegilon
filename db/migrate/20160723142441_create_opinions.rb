class CreateOpinions < ActiveRecord::Migration[5.1]
  def change
    create_table :opinions do |t|
      t.text :content

      t.timestamps
    end
    add_index :opinions, [:created_at]
  end
end
