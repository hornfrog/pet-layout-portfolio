# CategoriesControllerはカテゴリに関する操作を管理するコントローラーです。
class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @recipes = @category.recipes.includes(:user)
  end
end
