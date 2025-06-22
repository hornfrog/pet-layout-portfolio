require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:recipe) { build(:recipe, user: user, category: category) }

  describe 'バリデーション' do
    it 'タイトルが必須である' do
      recipe.title = nil
      expect(recipe).not_to be_valid
    end

    it 'レイアウト内容が空欄でない' do
      recipe.description = nil
      expect(recipe).not_to be_valid
    end

    it 'ユーザーが必須である' do
      recipe.user = nil
      expect(recipe).not_to be_valid
    end

    it 'カテゴリが必須である' do
      recipe.category = nil
      expect(recipe).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'ユーザに属している' do
      expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it 'カテゴリに属している' do
      expect(described_class.reflect_on_association(:category).macro).to eq(:belongs_to)
    end

    it 'いいねが複数付く' do
      expect(described_class.reflect_on_association(:likes).macro).to eq(:has_many)
    end
  end

  describe 'メソッド' do
    describe '#search_by_keyword' do
      let!(:matched) { create(:recipe, title: 'キーワードあり') }
      let!(:not_matched) { create(:recipe, title: '関係なし') }

      it 'キーワードに一致するレシピが含まれること' do
        result = described_class.search_by_keyword('キーワード')
        expect(result).to include(matched)
      end

      it 'キーワードに一致しないレシピが含まれないこと' do
        result = described_class.search_by_keyword('キーワード')
        expect(result).not_to include(not_matched)
      end
    end
  end
end
