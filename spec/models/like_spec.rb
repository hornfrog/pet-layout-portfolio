require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'バリデーション' do
    subject(:like) { create(:like) }

    it '同じユーザーが同じレイアウトに複数回いいねできないこと' do
      expect(like).to validate_uniqueness_of(:user_id).scoped_to(:recipe_id)
    end

    it 'ユーザーが設定されていること' do
      like.user = nil
      expect(like).not_to be_valid
    end

    it 'レイアウトが設定されていること' do
      like.recipe = nil
      expect(like).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:recipe) }
  end

  describe 'Factoryの有効性' do
    it '有効なファクトリであること' do
      expect(build(:like)).to be_valid
    end
  end

  describe 'ユニーク制約の境界テスト' do
    let(:user) { create(:user) }
    let(:first_recipe) { create(:recipe) }
    let(:second_recipe) { create(:recipe) }

    it '同じユーザーが別のレイアウトにいいねできる' do
      create(:like, user: user, recipe: first_recipe)
      new_like = build(:like, user: user, recipe: second_recipe)
      expect(new_like).to be_valid
    end

    it '同じレイアウトに複数のユーザーがいいねできること' do
      create(:like, user: user, recipe: first_recipe)
      another_user = create(:user)
      new_like = build(:like, user: another_user, recipe: first_recipe)
      expect(new_like).to be_valid
    end
  end
end
