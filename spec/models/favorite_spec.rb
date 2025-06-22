require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'バリデーション' do
    subject(:favorite) { build(:favorite) }

    it '同じユーザーが同じレイアウトを複数回お気に入りできないこと' do
      favorite = create(:favorite)
      duplicate = build(:favorite, user: favorite.user, recipe: favorite.recipe)
      expect(duplicate).not_to be_valid
    end

    it 'ユーザーが設定されていること' do
      favorite.user = nil
      expect(favorite).not_to be_valid
    end

    it 'レイアウトが設定されていること' do
      favorite.recipe = nil
      expect(favorite).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:recipe) }
  end

  describe 'FactoryBotで作成したお気に入りが有効であること' do
    it '有効なファクトリであること' do
      expect(build(:favorite)).to be_valid
    end
  end
end
