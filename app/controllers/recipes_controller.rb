# RecipesController はレシピの CRUD 操作を管理するコントローラーです。
class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_recipe, only: [:edit, :update, :destroy, :show]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @parent_categories = Category.where(parent_id: nil)
    @recipes = fetch_recipes
    @total_recipes_count = @recipes.except(:group).count

    respond_to do |format|
      format.html
      format.json { render_recipes_json }
    end
  end

  def search
    @recipes = fetch_recipes
    apply_filters
    apply_sorting
    @total_recipes_count = @recipes.except(:group).count

    respond_to do |format|
      format.html
      format.json { render_recipes_json }
    end
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

  def fetch_recipes
    @recipes = base_recipes
    apply_search
    apply_filters
    apply_sorting
    @recipes = @recipes.includes(:category, :likes)
  end

  def base_recipes
    return Recipe.order(created_at: :desc) if params[:category_id].blank?

    category = Category.find(params[:category_id])
    category_ids = category.self_and_descendants_ids

    Recipe.where(category_id: category_ids)
          .or(Recipe.where(child_category_id: category_ids))
          .or(Recipe.where(grandchild_category_id: category_ids))
          .order(created_at: :desc)
  end

  def apply_search
    return if params[:keyword].blank?

    @recipes = @recipes.search_by_keyword(params[:keyword])
  end

  def apply_filters
    { category_id: params[:parent_category],
      child_category_id: params[:child_category],
      grandchild_category_id: params[:grandchild_category] }.each do |column, value|
      @recipes = @recipes.where(column => value) if value.present?
    end
  end

  def apply_sorting
    @recipes = case params[:sort]
               when "latest"
                 @recipes.reorder(created_at: :desc)
               when "oldest"
                 @recipes.reorder(created_at: :asc)
               when "likes"
                 @recipes.left_joins(:likes)
                         .group("recipes.id")
                         .reorder(Arel.sql("COUNT(likes.id) DESC, recipes.created_at DESC"))
               else
                 @recipes.reorder(created_at: :desc)
               end
  end

  def render_recipes_json
    html = render_to_string(partial: "recipes/recipe_list", formats: [:html], locals: { recipes: @recipes })
    count = @total_recipes_count.is_a?(Hash) ? @total_recipes_count.values.sum : @total_recipes_count
    render json: { html: html, count: count }
  end
end
