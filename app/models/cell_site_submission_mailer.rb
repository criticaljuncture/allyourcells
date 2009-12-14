class CellSiteSubmissionMailer < ActionMailer::Base
  def valid_known_user(submission)
    subject    'Cell Site Accepted'
    recipients submission.cell_site.creator.email
    from       'submit@allyourcells.com'
    sent_on    Time.now
    
    body       :cell_site => submission.cell_site
  end
  
  def valid_unknown_user(submission)
    subject    "Cell Site Accepted Pending Account Creation"
    recipients submission.cell_site.creator.email
    from       'submit@allyourcells.com'
    sent_on    Time.now
    
    body       :password_reset_url => edit_password_reset_url(submission.cell_site.creator.perishable_token)
  end
  
  def invalid(submission)
    subject    "Invalid Submission"
    recipients submission.sender_email
    from       'submit@allyourcells.com'
    sent_on    Time.now
    
    body       :errors => submission.errors, :subject => submission.subject
  end
end
