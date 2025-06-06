module Recipes
  # Recipes::Fetcher は、レシピの検索、フィルタリング、ソートを行うサービスクラスです。
  # ファットコントローラー対策のために作成され、必要なレシピを処理します。
  #
  # 使用方法:
  #   Recipes::Fetcher.new(params: params).call
  class Fetcher
    def initialize(params:)
      @params = params
      @recipes = base_recipes
    end

    def call
      apply_search
      apply_filters
      apply_sorting

      @total_count = @recipes.count

      @recipes = @recipes.includes(:category, :likes).page(params[:page]).per(9)
    end

    private

    attr_reader :params

    def base_recipes
      Recipe.order(created_at: :desc)
    end

    def apply_search
      return if @params[:keyword].blank?

      @recipes = @recipes.search_by_keyword(@params[:keyword])
    end

    def apply_filters
      category_id = @params[:grandchild_category].presence ||
                    @params[:child_category].presence ||
                    @params[:parent_category].presence ||
                    @params[:category_id].presence

      return if category_id.blank?

      category = Category.find_by(id: category_id)
      return unless category

      descendant_ids = category.self_and_descendants_ids
      @recipes = @recipes.where(category_id: descendant_ids)
    end

    def apply_sorting
      @recipes =
        case params[:sort]
        when "oldest"
          @recipes.reorder(created_at: :asc)
        when "likes"
          @recipes.left_joins(:likes)
                  .group("recipes.id, recipes.created_at")
                  .reorder(Arel.sql("COUNT(likes.id) DESC, recipes.created_at DESC"))
        else
          @recipes.reorder(created_at: :desc)
        end
    end
  end
end
