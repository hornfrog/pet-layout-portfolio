class AddUniqueIndexToLikes < ActiveRecord::Migration[6.1]
  def change
    add_index :likes, [:user_id, :recipe_id], unique: true, name: "index_likes_on_user_id_and_recipe_id"
  end
end
