# ユーザー情報を管理するモデル
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :recipes, dependent: :destroy
  has_one_attached :avatar
  attr_accessor :remove_avatar

  def guest?
    email == "guest@example.com"
  end
end
