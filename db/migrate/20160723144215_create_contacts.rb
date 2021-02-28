class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :email
      t.references :contact_category, index: true
      t.string :title
      t.text :content

      t.timestamps
    end
    add_index :contacts, [:created_at]
  end
end
