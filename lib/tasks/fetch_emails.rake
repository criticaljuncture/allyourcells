namespace :cells do
  task :import_from_email => :environment do
    config = YAML::load(File.open("#{RAILS_ROOT}/config/mail.yml"))
    EmailMessage.connect(config)
    
    EmailSubmission.all.each do |email_submission| 
      if email_submission.save
        
        puts "#{email_submission.uid} SAVED"
        # if email_submission.creator.email_confirmed?
        #   # send response email
        # else
        #   # send email with token to validate email
        # end
      else
        puts "#{email_submission.uid} INVALID: #{email_submission.errors}"
        # send error email
      end
    end
  end
end