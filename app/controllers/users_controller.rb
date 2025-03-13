# UsersControllerはユーザーのプロフィール関連を管理するコントローラーです
class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    @user.avatar.purge if params[:user][:remove_avatar] == "1"

    if @user.update(user_params)
      flash[:notice] = I18n.t('notices.profile_updated')
      redirect_to @user
    else
      render :edit
    end
  end

  def recipes
    @user = User.find(params[:id])
    @recipes = @user.recipes
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile, :avatar, :remove_avatar)
  end

  def correct_user
    redirect_to root_path unless current_user == User.find(params[:id])
  end
end
