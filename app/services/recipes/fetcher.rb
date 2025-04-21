# frozen_string_literal: true

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
      @recipes.includes(:category, :likes).page(params[:page]).per(9)
    end

    private

    attr_reader :params

    def base_recipes
      return Recipe.order(created_at: :desc) if params[:category_id].blank?

      category = Category.find(params[:category_id])
      category_ids = category.self_and_descendants_ids

      Recipe.where(category_id: category_ids)
            .or(Recipe.where(child_category_id: category_ids))
            .or(Recipe.where(grandchild_category_id: category_ids))
            .order(created_at: :desc)
    end

    def apply_search
      return if params[:keyword].blank?

      @recipes = @recipes.search_by_keyword(params[:keyword])
    end

    def apply_filters
      filters = {
        category_id: params[:parent_category],
        child_category_id: params[:child_category],
        grandchild_category_id: params[:grandchild_category]
      }

      filters.each do |column, value|
        @recipes = @recipes.where(column => value) if value.present?
      end
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
