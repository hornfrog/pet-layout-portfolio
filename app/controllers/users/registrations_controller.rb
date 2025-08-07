module Users
  # Users::RegistrationsController はユーザー登録関連の処理を管理するコントローラーです。
  # rubocop:disable Rails/LexicallyScopedActionFilter
  # Devise のアクションは継承されているが、before_action の対象としているため
  class RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_user!, only: [:show]
    before_action :set_new_breadcrumb, only: [:new, :create]
    before_action :set_breadcrumbs_for_edit, only: [:edit, :update]
    before_action :reject_guest_user, only: [:edit, :update]

    def show
      add_breadcrumb("アカウント情報")

      @user = current_user
    end

    def update
      if current_user.update_with_password(account_update_params)
        bypass_sign_in(current_user)
        flash[:notice] = t("notices.account_updated")
        redirect_to account_path
      else
        render :edit
      end
    end

    private

    def set_new_breadcrumb
      add_breadcrumb("新規登録")
    end

    def set_breadcrumbs_for_edit
      add_breadcrumb("アカウント情報", account_path)
      add_breadcrumb("アカウント編集")
    end

    def reject_guest_user
      if current_user&.guest?
        redirect_to root_path, alert: "ゲストユーザーはアカウントの編集はできません。"
      end
    end
  end
end
# rubocop:enable Rails/LexicallyScopedActionFilter
