# LikesController は「いいね」の操作を管理するコントローラーです。
class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user
  before_action :set_recipe, only: [:create, :destroy]

  def create
    return head :forbidden if @recipe.user == current_user

    @like = current_user.likes.find_or_initialize_by(recipe: @recipe)

    if @like.persisted? || @like.save
      render json: { status: "success", likes_count: @recipe.likes.count }
    else
      render json: { status: "error" }, status: :unprocessable_entity
    end
  end

  def destroy
    @like = current_user.likes.find_by(recipe: @recipe)

    if @like&.destroy
      render json: { status: "success", likes_count: @recipe.likes.count }
    else
      render json: { status: "error" }, status: :unprocessable_entity
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def reject_guest_user
    return unless current_user.guest?

    render json: { status: "error" }, status: :forbidden
  end
end
