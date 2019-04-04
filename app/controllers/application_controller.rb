class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :viewer_category, :current_customer?
  before_action :set_cart

  def set_cart
    @cart ||= Cart.new(session[:cart])
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?
    current_user&.user?
  end
  def current_customer?
    current_user == nil || current_user&.user?
  end

  def current_admin?
    current_user&.admin?
  end

  def current_merchant?
    current_user&.merchant?
  end


  def current_visitor?
    current_user == nil
  end

  def viewer_category
    if current_user?
      'user'
    elsif current_merchant?
      'merchant'
    elsif current_admin?
      'admin'
    else
      'visitor'
    end
  end
  def render_404
    render status: 404, file: "#{Rails.root}/public/404.html"
  end
end
