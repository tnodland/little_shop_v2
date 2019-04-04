class Admin::BaseController < ApplicationController
  before_action :require_admin

  def require_admin
    render status: 404 unless current_admin?
  end
end
