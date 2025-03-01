# Categoryはカテゴリ情報を管理するモデルです。
class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category", optional: true
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy, inverse_of: :parent
  has_many :recipes, dependent: :destroy

  def self_and_ancestors
    parent ? parent.self_and_ancestors + [self] : [self]
  end

  def self_and_descendants_ids
    [id] + subcategories.flat_map(&:self_and_descendants_ids)
  end
end
