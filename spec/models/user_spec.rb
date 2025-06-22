require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it { is_expected.to validate_presence_of(:name).on(:profile_update) }
    it { is_expected.to validate_length_of(:name).is_at_most(20).on(:profile_update) }
  end

  describe 'アソシエーション' do
    it { is_expected.to have_many(:recipes).dependent(:destroy) }
    it { is_expected.to have_one_attached(:avatar) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:liked_recipes).through(:likes) }
    it { is_expected.to have_many(:favorites).dependent(:destroy) }
  end

  describe '#guest?（ゲスト判定）' do
    it 'ユーザーのメールアドレスがゲスト用ならtrueを返す' do
      user = described_class.new(email: "guest@example.com")
      expect(user.guest?).to be true
    end

    it 'ユーザーのメールアドレスがゲスト用でなければfalseを返す' do
      user = described_class.new(email: "foo@example.com")
      expect(user.guest?).to be false
    end
  end

  describe '#liked?（いいね判定）' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe) }

    it 'ユーザーがそのレシピをいいねしている場合、trueを返す' do
      create(:like, user: user, recipe: recipe)
      expect(user.liked?(recipe)).to be true
    end

    it 'ユーザーがそのレシピをいいねしていない場合、falseを返す' do
      expect(user.liked?(recipe)).to be false
    end
  end
end
