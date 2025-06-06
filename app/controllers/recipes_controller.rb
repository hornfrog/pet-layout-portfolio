# RecipesController はレシピの CRUD 操作を管理するコントローラーです。
class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_recipe, only: [:edit, :update, :destroy, :show]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  before_action :assign_category, only: [:create, :update]

  def index
    add_breadcrumb("レイアウト一覧", recipes_path)
    load_recipes
    respond_to_format
  end

  def search
    add_breadcrumb("レイアウト一覧", recipes_path)
    add_breadcrumb("検索結果")
    load_recipes
    respond_to_format
  end

  def show
    add_breadcrumbs_for(@recipe)
    @categories = Category.where(parent_id: nil)
  end

  def new
    add_breadcrumb("新規投稿")
    @recipe = Recipe.new
    @categories = parent_categories_with_children
  end

  def edit
    add_breadcrumb(@recipe.title, recipe_path(@recipe))
    add_breadcrumb("編集")
    @categories = parent_categories_with_children
    setup_edit_categories(@recipe.category)
  end

  def create
    @recipe = current_user.recipes.build(recipe_params.except(:images))
    Recipes::RecipeCategoryAssigner.new(@recipe, params).assign

    if @recipe.save
      attach_images
      redirect_to @recipe, notice: t('notices.recipe_created')
    else
      add_breadcrumb("新規投稿")
      @categories = parent_categories_with_children
      render :new
    end
  end

  def update
    purge_images if removing_images?

    if @recipe.update(recipe_params.except(:images, :category_id, :child_category_id, :grandchild_category_id))
      attach_images
      redirect_to @recipe, notice: t('notices.recipe_updated')
    else
      add_breadcrumb(@recipe.title, recipe_path(@recipe))
      add_breadcrumb("編集")
      @categories = parent_categories_with_children
      setup_edit_categories(@recipe.category)
      render :edit
    end
  end

  def destroy
    @recipe.destroy
    redirect_to(
      request.referer&.include?(recipe_path(@recipe.id)) ? recipes_path : request.referer || recipes_path,
      notice: t('notices.recipe_deleted')
    )
  end

  private

  def load_recipes
    @recipes = Recipes::Fetcher.new(params: params).call
    @total_recipes_count = @recipes.except(:group).reorder(nil).count
  end

  def respond_to_format
    respond_to do |format|
      format.html
      format.json { render_recipes_json }
    end
  end

  def render_recipes_json
    html = render_to_string(partial: "recipes/recipe_list", formats: [:html], locals: { recipes: @recipes })
    count = @total_recipes_count.is_a?(Hash) ? @total_recipes_count.values.sum : @total_recipes_count
    render json: { html: html, count: count }
  end

  def set_recipe
    @recipe = Recipe.includes(:user).find(params[:id])
  end

  def authorize_user!
    redirect_to recipes_path, alert: t('alerts.no_permission') unless @recipe.user == current_user
  end

  def recipe_params
    params.require(:recipe).permit(
      :title, :description,
      :category_id, :child_category_id, :grandchild_category_id,
      images: []
    )
  end

  def removing_images?
    params[:removed_image_ids].present?
  end

  def purge_images
    Recipes::ImagesAttachmentService.new(@recipe, nil).purge(params[:removed_image_ids])
  end

  def attach_images
    Recipes::ImagesAttachmentService.new(@recipe, recipe_params[:images]).attach
  end

  def assign_category
    Recipes::RecipeCategoryAssigner.new(@recipe ||= Recipe.new, params).assign
  end

  def parent_categories_with_children
    Category.includes(:subcategories).where(parent_id: nil)
  end

  def add_breadcrumbs_for(recipe)
    recipe.category&.self_and_ancestors&.each do |cat|
      add_breadcrumb(cat.name, category_path(cat))
    end
    add_breadcrumb(recipe.title.presence || "タイトル無し")
  end

  def setup_edit_categories(category)
    @selected_category = category
    @parent_category, @child_category, @grandchild_category = resolve_category_hierarchy(category)
    @child_categories = @parent_category ? Category.where(parent_id: @parent_category.id) : []
    @grandchild_categories = @child_category ? Category.where(parent_id: @child_category.id) : []
  end

  def resolve_category_hierarchy(category)
    return [nil, nil, nil] unless category

    if category.parent&.parent
      [category.parent.parent, category.parent, category]
    elsif category.parent
      [category.parent, category, nil]
    else
      [category, nil, nil]
    end
  end
end
