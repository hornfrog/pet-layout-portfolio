# CategoriesControllerはカテゴリに関する操作を管理するコントローラーです。
class CategoriesController < ApplicationController
  def show
    set_category_and_breadcrumbs
    prepare_recipes_data
    respond_to_format
  end

  def children
    @children = Category.where(parent_id: params[:parent_id])
    render json: @children
  end

  private

  def set_category_and_breadcrumbs
    @category = Category.find(params[:id])
    @category.self_and_ancestors.each do |ancestor|
      add_breadcrumb(ancestor.name, category_path(ancestor))
    end
    params[:category_id] = @category.id
  end

  def prepare_recipes_data
    @recipes = Recipes::Fetcher.new(params: params).call
    @total_recipes_count = @recipes.except(:group).reorder(nil).count
  end

  def respond_to_format
    respond_to do |format|
      format.html
      format.json { render_recipes_json }
    end
  end
end
