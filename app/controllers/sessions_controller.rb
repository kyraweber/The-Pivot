class SessionsController < ApplicationController
  before_action :store_url, only: [:new]

  def store_url
    session[:previous_url] = request.referrer
  end

  def new
  end

  def create
    @user = User.find_by(username: params[:session][:username])
    if @user && @user.authenticate(params[:session][:password])
      flash[:notice] = "Successfully logged in as #{@user.username}"
      session[:user_id] = @user.id
      if @user.admin?
        redirect_to admin_path
      else
        redirect_to session[:previous_url]
      end
    else
      flash[:error] = "Login failed"
      render :new
    end
  end

  def destroy
    session.clear
    flash[:notice] = "You have been logged out"
    redirect_to root_path
  end
end
