class UserMailer < ActionMailer::Base
  def password_reset_instructions(user)
    subject    "Password Reset Instructions"
    from       'All Your Cells <donotreply@allyourcells.com>'
    headers    "return-path" => 'donotreply@allyourcells.com'
    recipients user.email
    sent_on    Time.now
    body       :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end
