class UsersController < ApplicationController
  before_filter :require_not_logged_in, :only => [:new, :create]
  before_filter :require_login, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user].except(:sign_in_type))
    if @user.save
      @user.deliver_account_activation_instructions!
      flash[:notice] = "An email has been sent to you with a link to complete your registration."
      redirect_to root_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end
 
  def edit
    @user = @current_user
  end
  
  def new_username
    @user = current_user
  end
  
  def create_username
    if @user.login.present?
      flash[:error] = 'You can not change your username at this time'
      redirect_to account_url
    end
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    end
    
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
end