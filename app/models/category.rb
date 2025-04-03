# Categoryはカテゴリ情報を管理するモデルです。
class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category", optional: true
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy, inverse_of: :parent
  has_many :recipes, dependent: :destroy

  def self_and_descendants_ids
    [id] + descendant_ids
  end

  def self_and_ancestors
    ancestors = []
    current = self
    ancestors << current while (current = current.parent)
    ancestors.reverse
  end

  def descendant_ids
    subcategories.map(&:id) + subcategories.flat_map(&:descendant_ids)
  end
end
