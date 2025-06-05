# RecipesController はレシピの CRUD 操作を管理するコントローラーです。
class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_recipe, only: [:edit, :update, :destroy, :show]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  before_action :set_category_id_from_params, only: [:create, :update]

  def index
    add_breadcrumb("レイアウト一覧", recipes_path)
    @parent_categories = Category.where(parent_id: nil)
    fetch_recipes_with_total_count
    respond_to_format
  end

  def search
    add_breadcrumb("レイアウト一覧", recipes_path)
    add_breadcrumb("検索結果")
    fetch_recipes_with_total_count
    respond_to_format
  end

  def show
    add_breadcrumbs_for(@recipe)
    @categories = Category.where(parent_id: nil)
  end

  def new
    add_breadcrumb("新規投稿")
    @recipe = Recipe.new
    @categories = Category.includes(:subcategories).where(parent_id: nil)
  end

  def edit
    add_breadcrumb(@recipe.title, recipe_path(@recipe))
    add_breadcrumb("編集")
    @categories = Category.includes(:subcategories).where(parent_id: nil)
    setup_edit_categories(@recipe.category)
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user

    if @recipe.save
      attach_new_images
      redirect_to @recipe, notice: I18n.t('notices.recipe_created')
    else
      add_breadcrumb("新規投稿")
      @categories = Category.includes(:subcategories).where(parent_id: nil)
      render :new
    end
  end

  def update
    purge_removed_images if removing_images?
    category_id = @recipe.category_id

    if @recipe.update(recipe_params.except(:images, :category_id, :child_category_id, :grandchild_category_id))
      @recipe.update(category_id: category_id) if category_id.present?
      attach_new_images
      redirect_to @recipe, notice: I18n.t('notices.recipe_updated')
    else
      add_breadcrumb(@recipe.title, recipe_path(@recipe))
      add_breadcrumb("編集")
      @categories = Category.includes(:subcategories).where(parent_id: nil)
      setup_edit_categories(@recipe.category)
      render :edit
    end
  end

  def destroy
    @recipe.destroy
    redirect_to(
      request.referer&.include?(recipe_path(@recipe.id)) ? recipes_path : request.referer || recipes_path,
      notice: I18n.t('notices.recipe_deleted')
    )
  end

  private

  def fetch_recipes_with_total_count
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
    redirect_to recipes_path, alert: I18n.t('alerts.no_permission') unless @recipe.user == current_user
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

  def purge_removed_images
    params[:removed_image_ids].each do |id|
      image = @recipe.images.find_by(id: id)
      image&.purge
    end
  end

  def attach_new_images
    if recipe_params[:images]
      recipe_params[:images].each do |image|
        @recipe.images.attach(image)
      end
    end
  end

  def set_category_id_from_params
    category_id =
      params.dig(:recipe, :grandchild_category_id).presence ||
      params.dig(:recipe, :child_category_id).presence ||
      params.dig(:recipe, :category_id)

    return if category_id.blank?

    if action_name == 'create'
      @recipe = current_user.recipes.build(recipe_params.except(:images))
    elsif action_name == 'update'
      @recipe.assign_attributes(recipe_params.except(:images))
    end

    @recipe.category_id = category_id
  end

  def add_breadcrumbs_for(recipe)
    category = recipe.category
    category.self_and_ancestors.each do |cat|
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
