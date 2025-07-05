require 'rails_helper'

RSpec.describe 'アカウント編集', type: :system do
  let!(:user) { create(:user, email: 'old@example.com', password: 'password') }

  before do
    driven_by(:selenium_chrome)
    login_as(user, scope: :user)
    visit edit_user_registration_path
  end

  it 'メールアドレスとパスワードを更新できる' do
    fill_in 'user_email', with: 'new_email@example.com'
    fill_in 'user_current_password', with: 'password'
    fill_in 'user_password', with: 'newpassword'
    fill_in 'user_password_confirmation', with: 'newpassword'
    click_button '更新する'

    expect(page).to have_content('アカウント情報を更新しました')
  end

  it '無効なメールアドレス形式だとエラーになる' do
    fill_in 'user_email', with: 'invalid-email'
    fill_in 'user_current_password', with: 'password'
    fill_in 'user_password', with: 'newpassword'
    fill_in 'user_password_confirmation', with: 'newpassword'
    click_button '更新する'

    expect(page).to have_content('メールアドレスは不正な値です')
  end

  it '現在のパスワードが空だと更新できない' do
    fill_in 'user_email', with: 'test@example.com'
    click_button '更新する'

    expect(page).to have_content('現在のパスワードを入力してください')
  end
end
