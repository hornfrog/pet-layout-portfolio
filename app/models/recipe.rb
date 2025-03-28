# Recipeはレシピ情報を管理するモデルです。
class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :child_category, class_name: "Category", optional: true
  belongs_to :grandchild_category, class_name: "Category", optional: true
  has_one_attached :image
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  scope :search_by_keyword, lambda { |keyword|
    if keyword.present?
      where("title LIKE :keyword OR description LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%")
    else
      none
    end
  }

  def category_hierarchy
    [category, child_category, grandchild_category].compact
  end
end
