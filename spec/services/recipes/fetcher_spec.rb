require 'rails_helper'

RSpec.describe Recipes::Fetcher, type: :service do
  subject(:result) { described_class.new(params: params).call }

  let(:parent_category) { create(:category) }
  let!(:newer_recipe)   { create(:recipe, title: 'New', created_at: 1.day.ago, category: parent_category) }
  let!(:older_recipe)   { create(:recipe, title: 'Old', created_at: 3.days.ago, category: parent_category) }
  let!(:liked_recipe)   { create(:recipe, title: 'Popular', created_at: 2.days.ago, category: parent_category) }

  before { create_list(:like, 3, recipe: liked_recipe) }

  describe '#call' do
    context 'when keyword matches a recipe title' do
      let(:params) { { keyword: 'New' } }

      it '一致するレイアウトのみを返すこと' do
        expect(result).to contain_exactly(newer_recipe)
      end
    end

    context 'when keyword does not match any recipe' do
      let(:params) { { keyword: 'Nonexistent' } }

      it '空の結果を返すこと' do
        expect(result).to be_empty
      end
    end

    context 'when filtering by grandchild category' do
      let(:child)      { create(:category, parent: parent_category) }
      let(:grandchild) { create(:category, parent: child) }
      let!(:recipe_in_grandchild) { create(:recipe, category: grandchild) }
      let(:params) { { grandchild_category: grandchild.id } }

      it 'その孫カテゴリのレイアウトのみを返すこと' do
        expect(result).to contain_exactly(recipe_in_grandchild)
      end
    end

    context 'when sorting by likes' do
      let(:params) { { sort: 'likes' } }

      it 'いいね数が多い順にレイアウトを返すこと' do
        expect(result.first).to eq(liked_recipe)
      end
    end

    context 'when sorting by oldest' do
      let(:params) { { sort: 'oldest' } }

      it '作成日時が一番古いレイアウトを先頭に返すこと' do
        expect(result.first).to eq(older_recipe)
      end
    end
  end
end
