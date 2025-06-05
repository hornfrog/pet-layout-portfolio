# Recipeはレシピ情報を管理するモデルです。
class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :child_category, class_name: "Category", optional: true
  belongs_to :grandchild_category, class_name: "Category", optional: true
  has_many_attached :images
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  validates :title, presence: true, length: { maximum: 30 }
  validates :category_id, presence: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo
  validates :description, presence: true, length: { maximum: 500 }

  scope :search_by_keyword, lambda { |keyword|
    if keyword.present?
      where("title LIKE :keyword OR description LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%")
    else
      none
    end
  }

  scope :search_by_category, lambda { |category_id|
    if category_id.present?
      category = Category.find(category_id)
      ids = category.self_and_descendants_ids.to_a
      where(category_id: ids)
        .or(where(child_category_id: ids))
        .or(where(grandchild_category_id: ids))
    else
      all
    end
  }

  def category_hierarchy
    [category, child_category, grandchild_category].compact
  end
end
