namespace :cells do
  task :import_from_email => :environment do
    config = YAML::load(File.open("#{RAILS_ROOT}/config/mail.yml"))
    EmailSubmission.connect(config)
    
    EmailSubmission.all.each do |message| 
      if email_submission.valid?
        email_submission.save!
        
        if email_submission.creator.email_confirmed?
          # send response email
        else
          # send email with token to validate email
        end
      else
        # send error email
      end
    end
  end
end