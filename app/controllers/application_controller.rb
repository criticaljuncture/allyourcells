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
  include Locator
  helper_method :current_location
  
  # use mongo as rails log
  # include MongoDBLogging
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  protected
  
  def require_not_logged_in
    if current_user
      redirect_back_or_default root_url
      return false
    end
  end
  
  # add generic metadata for logging to this method
  # individual controllers can also have more specific methods to add data to the log
  def add_metadata_to_log
    if Rails.logger.respond_to?(:add_metadata)
      if current_user
        Rails.logger.add_metadata(:user_id => current_user.id)
      end
    end
  end
end
