require 'rails_helper'

RSpec.describe 'レイアウト投稿', type: :system do
  let!(:category) { create(:category, name: '爬虫類') }

  def test_image
    Rails.root.join('spec/fixtures/test_image.png')
  end

  def fill_recipe_form(title:, description:, image_count:)
    visit new_recipe_path
    fill_in 'recipe_title', with: title
    fill_in 'recipe_description', with: description
    select '爬虫類', from: 'parent_category'
    attach_file 'image-input', [test_image] * image_count, make_visible: true
  end

  context 'when the user is not logged in' do
    it 'does not show the post button' do
      visit root_path
      expect(page).not_to have_link('新規投稿')
    end
  end

  context 'when a regular user is logged in' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:own_recipe) { create(:recipe, user: user, category: category) }
    let!(:other_recipe) { create(:recipe, user: other_user, category: category) }

    before do
      login_as(user)
    end

    describe '新規投稿' do
      before do
        fill_recipe_form(title: 'お試しのレイアウト', description: 'お試し投稿の説明文です。', image_count: 5)
        click_button '投稿する'
      end

      it '投稿完了メッセージが表示される' do
        expect(page).to have_content('レイアウトを投稿しました！')
      end

      it '投稿タイトルが表示される' do
        expect(page).to have_content('お試しのレイアウト')
      end

      it '投稿画像が5枚表示される' do
        expect(page).to have_selector('img', count: 5, wait: 10)
      end
    end

    describe '画像制限バリデーション' do
      it '6枚選択するとエラーメッセージが表示される' do
        visit new_recipe_path
        attach_file 'image-input', [test_image] * 6, make_visible: true
        expect(page).to have_content('画像は最大 5 枚まで選択できます。')
      end
    end

    describe '自分の投稿の操作ボタン' do
      before { visit recipe_path(own_recipe) }

      it '編集ボタンが表示される' do
        expect(page).to have_link('編集', wait: 5)
      end

      it '削除ボタンが表示される' do
        expect(page).to have_link('削除', wait: 5)
      end
    end
  
    describe '他人の投稿の操作ボタン' do
      before { visit recipe_path(other_recipe) }

      it '編集ボタンが表示されない' do
        expect(page).not_to have_link('編集')
      end

      it '削除ボタンが表示されない' do
        expect(page).not_to have_link('削除')
      end
    end

    describe '投稿編集' do
      before do
        visit recipe_path(own_recipe)
        click_link '編集'
        fill_in 'recipe_title', with: '編集後のタイトル'
        click_button '更新する'
      end

      it '編集完了メッセージが表示される' do
        expect(page).to have_content('レイアウトを更新しました！')
      end

      it '編集されたタイトルが表示される' do
        expect(page).to have_content('編集後のタイトル')
      end
    end

    describe '投稿削除' do
      it '投稿を削除できる' do
        visit recipe_path(own_recipe)
        accept_confirm { click_link '削除' }
        expect(page).to have_content('レイアウトを削除しました！')
      end
    end
  end
end
