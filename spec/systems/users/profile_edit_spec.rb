require 'rails_helper'

RSpec.describe 'プロフィール編集', type: :system do
  let(:user) { create(:user, password: 'password') }

  before do
    login_as(user, scope: :user)
  end

  def test_image
    Rails.root.join('spec/fixtures/test_image.png')
  end

  it '正常にプロフィールを編集できる' do
    visit edit_user_path(user)

    attach_file 'avatar-input', test_image
    fill_in 'user_name', with: '新しい名前'
    fill_in 'user_profile', with: 'こんにちは'
    
    click_button '更新する'

    expect(page).to have_content('プロフィールを更新しました')
  end
end
