class CartsController < ApplicationController
  before_action :require_customer
  def index
  end

  def create
  end
  private
    def require_customer
      render file: "/public/404" unless current_customer?
    end
end
