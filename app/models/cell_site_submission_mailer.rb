class CellSiteSubmissionMailer < ActionMailer::Base
  def valid(sent_at = Time.now)
    subject    'VALID'
    recipients 'acarpen@wested.org'
    from       'submit@allyourcells.com'
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def invalid(sent_at = Time.now)
    subject    'CellSiteSubmissions#invalid'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end
end
