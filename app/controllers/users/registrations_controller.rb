module Users
  # Users::RegistrationsController はユーザー登録関連の処理を管理するコントローラーです。
  class RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_user!, only: [:show]
    def show
      add_breadcrumb("アカウント情報")

      @user = current_user
    end

    def new
      add_breadcrumb("新規登録")
      super
    end

    def edit
      add_breadcrumb("アカウント情報", account_path)
      add_breadcrumb("アカウント編集")
    end
  end
end
