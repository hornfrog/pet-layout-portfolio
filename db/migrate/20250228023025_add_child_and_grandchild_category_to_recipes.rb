class AddChildAndGrandchildCategoryToRecipes < ActiveRecord::Migration[6.1]
  def change
    add_column :recipes, :child_category_id, :bigint
    add_column :recipes, :grandchild_category_id, :bigint

    add_index :recipes, :child_category_id
    add_index :recipes, :grandchild_category_id
  end
end
