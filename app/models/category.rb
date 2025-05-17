# Categoryはカテゴリ情報を管理するモデルです。
class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category", optional: true
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy, inverse_of: :parent
  has_many :recipes, dependent: :destroy

  def self_and_descendants_ids
    [id] + Category.where(parent_id: id).flat_map do |child|
      [child.id] + child.self_and_descendants_ids
    end
  end

  def self_and_ancestors
    ancestors = [self]
    current = self
    ancestors.unshift(current = current.parent) while current&.parent
    ancestors.compact
  end

  def descendant_ids
    subcategories.map(&:id) + subcategories.flat_map(&:descendant_ids)
  end
end
