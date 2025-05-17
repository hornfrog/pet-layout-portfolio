# すべてのコントローラーの基盤となるコントローラー
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_categories
  before_action :add_home_breadcrumb

  helper_method :breadcrumbs

  def add_breadcrumb(name, path = nil)
    @breadcrumbs ||= []
    @breadcrumbs << [name, path]
  end

  def breadcrumbs
    @breadcrumbs || []
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def set_categories
    @categories = Category.where(parent_id: nil).includes(:subcategories)
  end

  def add_home_breadcrumb
    return if request.path == root_path

    add_breadcrumb "ホーム", root_path
  end
end
