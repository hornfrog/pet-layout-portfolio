require 'rails_helper'

RSpec.describe 'カテゴリ機能', type: :system do
  let!(:parent) { create(:category, name: '爬虫類') }
  let!(:child) { create(:category, name: 'トカゲ', parent: parent) }
  let!(:grandchild) { create(:category, name: '樹上棲', parent: child) }

  let!(:parent_recipe) { create(:recipe, title: '親のレイアウト', category: parent) }
  let!(:grandchild_recipe) { create(:recipe, title: '孫のレイアウト', category: grandchild) }

  describe 'ナビゲーションメニュー表示' do
    before { visit root_path }

    it '親カテゴリが表示される' do
      expect(page).to have_link('爬虫類', href: category_path(parent))
    end

    it '孫カテゴリまで表示される' do
      find('li.dropdown', text: '爬虫類').hover
      find('ul.dropdown-menu li.dropdown', text: 'トカゲ').hover
      expect(page).to have_link('樹上棲', href: category_path(grandchild), wait: 10)
    end
  end

  describe 'カテゴリ詳細ページ' do
    it '親カテゴリでは子、孫のレイアウトも表示される' do
      visit category_path(parent)
      expect(page).to have_content('親のレイアウト')
      expect(page).to have_content('孫のレイアウト')
    end

    it '孫カテゴリでは自分のレイアウトだけ表示される' do
      visit category_path(grandchild)
      expect(page).to have_content('孫のレイアウト')
      expect(page).not_to have_content('親のレイアウト')
    end
  end

  describe 'パンくずリスト' do
    it '階層的に表示され、各リンクが機能する' do
      visit category_path(grandchild)

      within('.breadcrumbs') do
        expect(page).to have_link('爬虫類', href: category_path(parent))
        expect(page).to have_link('トカゲ', href: category_path(child))
        expect(page).to have_content('樹上棲')
      end

      within('.breadcrumbs') { click_link '爬虫類' }
      expect(page).to have_current_path(category_path(parent))

      visit category_path(grandchild)
      within('.breadcrumbs') { click_link 'トカゲ' }
      expect(page).to have_current_path(category_path(child))
    end
  end
end
