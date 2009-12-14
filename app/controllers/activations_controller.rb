class ActivationsController < ApplicationController
  before_filter :require_not_logged_in
  before_filter :load_user_using_perishable_token

  def create
    @user.active = true
    @user.save(false)
    flash[:notice] = "You are now activated!"
    redirect_to login_url
  end
  
  private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id], 0)
    unless @user
      flash[:error] = "Your activation link is invalid."
      redirect_to root_url
    end
  end
end