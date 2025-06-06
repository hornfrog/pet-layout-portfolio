# favorites_controller はお気に入り機能の管理をするコントローラーです。
class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user, only: [:create, :destroy]

  def index
    add_breadcrumb("お気に入り一覧")

    @favorites = current_user.favorites.includes(recipe: :user).order(created_at: :desc)
    @favorite_count = @favorites.count
  end

  def create
    recipe = Recipe.find(params[:recipe_id])

    return head :forbidden if recipe.user == current_user

    favorite = current_user.favorites.build(recipe: recipe)

    if favorite.save
      render json: { status: "success", message: "お気に入りに追加しました。" }
    else
      render json: { status: "error" }, status: :unprocessable_entity
    end
  end

  def destroy
    recipe = Recipe.find(params[:recipe_id])
    favorite = current_user.favorites.find_by(recipe: recipe)

    if favorite&.destroy
      render json: { status: "success", message: "お気に入りを取り消しました。" }
    else
      render json: { status: "error", message: "お気に入り解除に失敗しました。" }
    end
  end

  private

  def reject_guest_user
    render json: { status: "error", message: "ゲストユーザーはお気に入りできません。" }, status: :forbidden if current_user.guest?
  end
end
