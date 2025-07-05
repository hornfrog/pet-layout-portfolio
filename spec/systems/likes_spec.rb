require 'rails_helper'

RSpec.describe 'いいね表示', type: :system do
  let!(:user) { create(:user) }
  let!(:poster) { create(:user) }

  let!(:liked_recipe) { create(:recipe, user: poster, title: 'いいね済レイアウト') }
  let!(:unliked_recipe) { create(:recipe, user: poster, title: '未いいねレイアウト') }
  let!(:like) { create(:like, user: user, recipe: liked_recipe) }

  before do
    driven_by(:selenium_chrome_headless)
    login_as(user)
    visit recipes_path
  end

  it 'いいね済みには赤いハートが表示される' do
    card = find('.recipe-card', text: 'いいね済レイアウト')
    within(card) do
      expect(page).to have_css('i.fa-solid.fa-heart', visible: true)
    end
  end

  it '未いいねには白いハートが表示される' do
    card = find('.recipe-card', text: '未いいねレイアウト')
    within(card) do
      expect(page).to have_css('i.fa-regular.fa-heart', visible: true)
    end
  end

  it 'レイアウトにいいね数が表示される' do
    card = find('.recipe-card', text: 'いいね済レイアウト')
    within(card) do
      count = find('.like-count').text.strip
      expect(count).to eq('1')
    end
  end

  it 'いいねがされていない場合0と表示される' do
    card = find('.recipe-card', text: '未いいねレイアウト')
    within(card) do
      count = find('.like-count').text.strip
      expect(count).to eq('0')
    end
  end
end
