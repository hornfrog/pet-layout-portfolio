# CategoriesControllerはカテゴリに関する操作を管理するコントローラーです。
class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    ids = @category.self_and_descendants_ids

    @recipes = Recipe.where(category_id: ids)
                     .or(Recipe.where(child_category_id: ids))
                     .or(Recipe.where(grandchild_category_id: ids))
                     .includes(:user)
  end

  def children
    @children = Category.where(parent_id: params[:parent_id])
    render json: @children
  end
end
