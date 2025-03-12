module Users
  # Users::RegistrationsController はユーザー登録関連の処理を管理するコントローラーです。
  class RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_user!

    def show
      @user = current_user
    end
  end
end
