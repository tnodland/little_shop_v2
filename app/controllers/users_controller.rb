class UsersController < ApplicationController
  before_action :require_user
  skip_before_action :require_user, only: [:new]
  def show
  end

  def new
  end

  private
    def require_user
      render file: "/public/404" unless current_user?
    end
end
