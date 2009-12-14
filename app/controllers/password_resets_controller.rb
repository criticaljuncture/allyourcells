class PasswordResetsController < ApplicationController
  skip_before_filter :require_login
  
  before_filter :require_not_logged_in
  before_filter :load_user_using_perishable_token, :only => [:edit,:update]

  def new
  end

  def create
    @user = User.find_by_email(params[:user][:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you." +
        " Please check your email."
      redirect_to root_url
    else
      flash[:error] = "No user was found with that email address."
      render :action => :new
    end
  end

  def update
    @user.password = params[:user][:password]
    if @user.save
      flash[:notice] = "Password successfully updated."
      redirect_to root_url
    else
      render :action => :edit
    end
  end

  private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = "Your password reset link has expired or is invalid; please request a new one below."
      render :action => :new
    end
  end
end
