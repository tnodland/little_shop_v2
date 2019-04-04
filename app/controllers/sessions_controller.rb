class SessionsController < ApplicationController
  def new
  end

  def create
    redirect_to profile_path
  end
end
