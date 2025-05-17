# UsersControllerはユーザーのプロフィール関連を管理するコントローラーです
class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def show
    add_breadcrumb("プロフィール")

    @user = User.find(params[:id])
  end

  def edit
    add_breadcrumb("プロフィール", current_user)
    add_breadcrumb("プロフィール編集")

    @user = current_user
  end

  def update
    @user = current_user
    purge_avatar_if_requested

    if @user.update(user_params)
      flash[:notice] = I18n.t('notices.profile_updated')
      redirect_to @user
    else
      render :edit
    end
  end

  def recipes
    add_breadcrumb("マイレイアウト")

    @user = User.find(params[:id])
    @recipes = @user.recipes
    @recipe_count = @recipes.count
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile, :avatar, :remove_avatar)
  end

  def correct_user
    redirect_to root_path unless current_user == User.find(params[:id])
  end

  def purge_avatar_if_requested
    return unless params[:user][:remove_avatar] == "true" && params[:user][:avatar].blank?

    @user.avatar.purge
  end
end
