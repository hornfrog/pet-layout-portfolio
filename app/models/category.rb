# Categoryはカテゴリ情報を管理するモデルです。
class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category", optional: true
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy, inverse_of: :parent
  has_many :recipes, dependent: :destroy
end
