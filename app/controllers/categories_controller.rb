# CategoriesControllerはカテゴリに関する操作を管理するコントローラーです。
class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    params[:category_id] = @category.id

    @recipes = Recipes::Fetcher.new(params: params).call
    @total_recipes_count = @recipes.except(:group).reorder(nil).count

    respond_to do |format|
      format.html
      format.json { render_recipes_json }
    end
  end

  def children
    @children = Category.where(parent_id: params[:parent_id])
    render json: @children
  end

  private

  def render_recipes_json
    render json: {
      html: render_to_string(
        partial: 'recipes/recipe_list',
        formats: [:html],
        locals: { recipes: @recipes, current_user: current_user }
      ),
      count: @recipes.except(:group).reorder(nil).count
    }
  end
end
