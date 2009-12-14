# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  # Authorization methods
  include AuthenticationUtils
  include AuthorizationUtils
  
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  
  # mapping
  include Cloudkicker
  include MapHelper
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  protected
  
  def require_not_logged_in
    if current_user
      redirect_back_or_default root_url
      return false
    end
  end
end
