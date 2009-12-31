=begin Schema Information

 Table name: users

  id                  :integer(4)      not null, primary key
  login               :string(255)     not null
  email               :string(255)     not null
  crypted_password    :string(255)     not null
  password_salt       :string(255)     not null
  persistence_token   :string(255)     not null
  single_access_token :string(255)     not null
  perishable_token    :string(255)     not null
  login_count         :integer(4)      default(0), not null
  failed_login_count  :integer(4)      default(0), not null
  last_request_at     :datetime
  current_login_at    :datetime
  last_login_at       :datetime
  current_login_ip    :string(255)
  last_login_ip       :string(255)
  created_at          :datetime
  updated_at          :datetime

=end Schema Information

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    # for available options see documentation in: Authlogic::ActsAsAuthentic
    c.crypto_provider                         = Authlogic::CryptoProviders::BCrypt
    c.login_field                             = :email
    c.validate_login_field                    = false
    c.validate_password_field                 = false
    c.require_password_confirmation           = false
  end
  
  define_completeness_scoring do
    check :login,          lambda { |u| u.login.present?      }, :high
    check :submitted_site, lambda { |u| u.cell_sites.present? }, :high
    check :email,          lambda { |u| u.email.present? },      :medium
  end
  
  
  attr_accessor :has_account
  attr_accessor :auto_generated
  attr_accessor :setup_step
  
  attr_protected :username, :setup_step
  
  has_many :cell_sites, :foreign_key => :creator_id
  validates_presence_of   :email
  validates_uniqueness_of :login, :allow_nil => true 
  
  validates_presence_of :password, :unless => Proc.new {|u| u.auto_generated || u.setup_step == 'username'}
  validates_length_of :password, :minimum => 6, :allow_nil => true
  
  attr_protected :active, :auto_generated
  
  def email=(email_address)
    email_address = email_address.downcase if email_address
    write_attribute('email', email_address)
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions!(self)
  end

  def deliver_account_activation_instructions!
    reset_perishable_token!
    UserMailer.deliver_activation_instructions!(self)
  end
  
  def sign_in_type
    'register'
  end
  
  def self.find_or_create_by_email!(email)
    user = find_by_email(email)
    
    if ! user
      user = User.new(:email => email)
      user.auto_generated = true
      user.save!
    end
    
    user
  end
  
end
