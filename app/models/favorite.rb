# Favoriteモデルはユーザーのお気に入り機能を管理します。
class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates :user_id, uniqueness: { scope: :recipe_id }
end
