class CreateContactCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_categories do |t|
      t.string :name
      t.boolean :active, default: true
      t.integer :output_number

      t.timestamps
    end
    add_index :contact_categories, [:output_number]
  end
end
