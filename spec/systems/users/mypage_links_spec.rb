require 'rails_helper'

RSpec.describe 'マイページリンク', type: :system do
  let!(:user) { create(:user) }

  before do
    driven_by(:selenium_chrome_headless)
    login_as(user, scope: :user)
    visit root_path
  end

  it 'アカウント情報リンクが表示されている' do
    find('#dropdownUser').click
    expect(page).to have_link('アカウント情報', href: account_path)
  end

  it 'プロフィールリンクが表示されている' do
    find('#dropdownUser').click
    expect(page).to have_link('プロフィール', href: user_path(user))
  end

  it 'マイレイアウトリンクが表示されている' do
    find('#dropdownUser').click
    expect(page).to have_link('マイレイアウト', href: recipes_user_path(user))
  end

  it 'お気に入り一覧リンクが表示されている' do
    find('#dropdownUser').click
    expect(page).to have_link('お気に入り一覧', href: favorites_path)
  end

  it 'アカウント情報リンクをクリックすると正しいページに遷移する' do
    find('#dropdownUser').click
    click_link 'アカウント情報'
    expect(current_path).to eq account_path
  end

  it 'プロフィールリンクをクリックすると正しいページに遷移する' do
    visit root_path
    find('#dropdownUser').click
    click_link 'プロフィール'
    expect(current_path).to eq user_path(user)
  end

  it 'マイレイアウトに遷移できる' do
    find('#dropdownUser').click
    click_link 'マイレイアウト'
    expect(current_path).to eq recipes_user_path(user)
  end

  it 'お気に入り一覧に遷移できる' do
    find('#dropdownUser').click
    click_link 'お気に入り一覧'
    expect(current_path).to eq favorites_path
  end
end
