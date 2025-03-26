# トップページの表示を管理するコントローラー
class HomeController < ApplicationController
  def index
    @recipes = Recipe.order(created_at: :desc).limit(5)
    @total_recipes_count = Recipe.count
  end
end
