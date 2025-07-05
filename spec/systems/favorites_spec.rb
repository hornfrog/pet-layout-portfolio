require 'rails_helper'

RSpec.describe 'お気に入り表示', type: :system do
  let!(:user) { create(:user) }
  let!(:poster) { create(:user) }
  let!(:recipe_favorited) { create(:recipe, user: poster, title: 'お気に入り済レイアウト') }
  let!(:recipe_not_favorited) { create(:recipe, user: poster, title: '未お気に入りレイアウト') }
  let!(:favorite) { create(:favorite, user: user, recipe: recipe_favorited) }

  before do
    driven_by(:selenium_chrome_headless)
    login_as(user)
    visit recipes_path
  end

  it 'お気に入り済には黄色い星が表示される' do
    card = find('.recipe-card', text: 'お気に入り済レイアウト')
    within(card) do
      expect(page).to have_css('i.fa-solid.fa-star')
    end
  end

  it '未お気に入りには白い星が表示される' do
    card = find('.recipe-card', text: '未お気に入りレイアウト')
    within(card) do
      expect(page).to have_css('i.fa-regular.fa-star')
    end
  end
end
