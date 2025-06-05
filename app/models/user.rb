# ユーザー情報を管理するモデル
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }, on: :profile_update

  has_many :recipes, dependent: :destroy
  has_one_attached :avatar
  has_many :likes, dependent: :destroy
  has_many :liked_recipes, through: :likes, source: :recipe
  has_many :favorites, dependent: :destroy
  attr_accessor :remove_avatar

  def guest?
    email == "guest@example.com"
  end

  def liked?(recipe)
    likes.exists?(recipe_id: recipe.id)
  end
end
