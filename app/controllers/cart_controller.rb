class CartController < ApplicationController
  before_action :require_customer
  def show
  end

  private
    def require_customer
      render file: "/public/404" unless current_customer?
    end
end
