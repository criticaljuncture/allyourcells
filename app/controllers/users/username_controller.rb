class Users::UsernameController < ApplicationController
  before_filter :require_login
  before_filter :require_no_username
  
  def new
    @user = current_user
  end
  
  def create
    @user = current_user
    @user.setup_step = 'username'
    @user.login = params[:user][:login]
    if @user.save
      flash[:notice] = "Username #{@user.login} has been added to your account!"
      redirect_to account_url
    else
      render :action => :new
    end
  end
  
  private
  
  def require_no_username
    if current_user.login.present?
      flash[:error] = 'You can not change your username at this time'
      redirect_to account_url
      return false
    else
      return true
    end
  end
end