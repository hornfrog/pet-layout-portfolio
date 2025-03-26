# RecipesController はレシピの CRUD 操作を管理するコントローラーです。
class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_recipe, only: [:edit, :update, :destroy, :show]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    if params[:category_id]
      category = Category.find(params[:category_id])
      category_ids = category.self_and_descendants_ids

      @recipes = Recipe.where(category_id: category_ids)
                       .or(Recipe.where(child_category_id: category_ids))
                       .or(Recipe.where(grandchild_category_id: category_ids))
                       .distinct
    else
      @recipes = Recipe.all
    end

    @total_recipes_count = @recipes.count
  end

  def show
    @categories = Category.where(parent_id: nil)
  end

  def new
    @recipe = Recipe.new
    @categories = Category.includes(:subcategories).where(parent_id: nil)
  end

  def edit; end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      redirect_to @recipe, notice: I18n.t('notices.recipe_created')
    else
      @categories = Category.includes(:subcategories).where(parent_id: nil)
      render :new
    end
  end

  def update
    @recipe.image.purge if params[:remove_image] == "1"

    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: I18n.t('notices.recipe_updated')
    else
      render :edit
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path, notice: I18n.t('notices.recipe_deleted')
  end

  private

  def set_recipe
    @recipe = Recipe.includes(:user).find(params[:id])
  end

  def authorize_user!
    redirect_to recipes_path, alert: I18n.t('alerts.no_permission') unless @recipe.user == current_user
  end

  def recipe_params
    params.require(:recipe).permit(:title, :description, :category_id, :child_category_id, :grandchild_category_id, :image)
  end
end
