# RecipesController はレシピの CRUD 操作を管理するコントローラーです。
class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_recipe, only: [:edit, :update, :destroy, :show]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @parent_categories = Category.where(parent_id: nil)
    @recipes = Recipes::Fetcher.new(params: params).call
    @total_recipes_count = @recipes.except(:group).reorder(nil).count

    respond_to do |format|
      format.html
      format.json { render_recipes_json }
    end
  end

  def search
    @recipes = Recipes::Fetcher.new(params: params).call
    @total_recipes_count = @recipes.except(:group).reorder(nil).count

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
    purge_removed_images if params[:removed_image_ids].present?

    if @recipe.update(recipe_params.except(:images))
      attach_new_images
      redirect_to @recipe, notice: I18n.t('notices.recipe_updated')
    else
      render :edit
    end
  end

  def destroy
    @recipe.destroy
    if request.referer&.include?(recipe_path(@recipe.id))
      redirect_to recipes_path, notice: I18n.t('notices.recipe_deleted')
    else
      redirect_to request.referer || recipes_path, notice: I18n.t('notices.recipe_deleted')
    end
  end

  def render_recipes_json
    html = render_to_string(partial: "recipes/recipe_list", formats: [:html], locals: { recipes: @recipes })
    count = @total_recipes_count.is_a?(Hash) ? @total_recipes_count.values.sum : @total_recipes_count
    render json: { html: html, count: count }
  end

  private

  def set_recipe
    @recipe = Recipe.includes(:user).find(params[:id])
  end

  def authorize_user!
    redirect_to recipes_path, alert: I18n.t('alerts.no_permission') unless @recipe.user == current_user
  end

  def recipe_params
    params.require(:recipe).permit(:title, :description, :category_id, :child_category_id, :grandchild_category_id, images: [])
  end

  def purge_removed_images
    params[:removed_image_ids].each do |id|
      image = @recipe.images.find_by(id: id)
      image&.purge
    end
  end

  def attach_new_images
    @recipe.images.attach(recipe_params[:images]) if recipe_params[:images]
  end
end
