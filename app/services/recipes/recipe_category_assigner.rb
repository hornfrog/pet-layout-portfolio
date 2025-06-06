module Recipes
  # カテゴリパラメータから適切なカテゴリIDを抽出し、
  # レシピに設定するサービスクラス
  #
  # 使用例:
  # Recipes::RecipeCategoryAssigner.new(recipe, params).assign
  class RecipeCategoryAssigner
    def initialize(recipe, params)
      @recipe = recipe
      @params = params
    end

    def assign
      category_id = extract_category_id
      return if category_id.blank?

      @recipe.category_id = category_id
    end

    private

    def extract_category_id
      @params.dig(:recipe, :grandchild_category_id).presence ||
        @params.dig(:recipe, :child_category_id).presence ||
        @params.dig(:recipe, :category_id)
    end

    def recipe_params
      @params.require(:recipe).permit(:title, :description, :category_id, :child_category_id, :grandchild_category_id, images: [])
    end
  end
end
