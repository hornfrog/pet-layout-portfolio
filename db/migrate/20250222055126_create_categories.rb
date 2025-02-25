class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
    add_index :categories, :parent_id
  end
end
