# Recipeはレシピ情報を管理するモデルです。
class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :child_category, class_name: "Category", optional: true
  belongs_to :grandchild_category, class_name: "Category", optional: true
  has_one_attached :image

  def category_hierarchy
    [category, child_category, grandchild_category].compact
  end
end
