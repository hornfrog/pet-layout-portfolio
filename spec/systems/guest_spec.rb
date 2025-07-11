require 'rails_helper'

RSpec.describe 'ゲストログイン機能', type: :system do
  let(:guest_user) do
    User.find_by(email: "guest@example.com") ||
      create(:user, email: "guest@example.com", name: "ゲストユーザー")
  end
  let!(:category) { create(:category, name: "爬虫類") }
  let!(:recipe) { create(:recipe, user: guest_user, category: category) }

  def test_image
    Rails.root.join("spec/fixtures/test_image.png")
  end

  before do
    driven_by(:selenium_chrome_headless)
    visit root_path
    click_button 'ゲストログイン'
  end

  describe 'ログイン後の動作' do
    it 'ゲストユーザーとしてログインできる' do
      expect(page).to have_content('ゲストユーザーとしてログインしました')
    end

    describe '投稿関連' do
      it '編集ボタンが表示されない' do
        visit recipe_path(recipe)
        expect(page).not_to have_link('編集')
      end

      it '削除ボタンが表示されない' do
        visit recipe_path(recipe)
        expect(page).not_to have_link('削除')
      end
    end

    describe 'ヘッダーメニューの表示制限' do
      before { find('.dropdown-toggle').click }

      it 'アカウント情報が表示されない' do
        expect(page).not_to have_link('アカウント情報')
      end

      it 'プロフィールが表示されない' do
        expect(page).not_to have_link('プロフィール')
      end

      it 'マイレイアウトが表示されない' do
        expect(page).not_to have_link('マイレイアウト')
      end

      it 'お気に入り一覧が表示されない' do
        expect(page).not_to have_link('お気に入り一覧')
      end
    end

    describe 'ログアウト' do
      it 'ログアウトできる' do
        find('.dropdown-toggle').click
        click_link 'ログアウト'
        expect(page).to have_button('ゲストログイン')
      end
    end
  end
end
