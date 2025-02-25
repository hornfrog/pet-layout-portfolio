# すべてのコントローラーの基盤となるコントローラー
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_categories

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def set_categories
    @categories = Category.where(parent_id: nil).includes(:subcategories)
  end
end
