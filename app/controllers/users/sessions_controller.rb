module Users
  # ユーザーのセッション（ログイン・ログアウト）を管理するコントローラー
  # @example ゲストログインの処理
  #   Users::SessionsController.new.guest_sign_in
  class SessionsController < Devise::SessionsController
    def new
      add_breadcrumb("ログイン")
      super
    end

    def guest_sign_in
      user = User.find_or_create_by!(email: "guest@example.com") do |u|
        u.password = SecureRandom.urlsafe_base64
        u.name = "ゲストユーザー"
      end
      sign_in user
      redirect_to root_path, notice: I18n.t("notices.guest_login")
    end
  end
end
