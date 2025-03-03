# トップページの表示を管理するコントローラー
class HomeController < ApplicationController
  def index
    @recipes = Recipe.all
  end
end
