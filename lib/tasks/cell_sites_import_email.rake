namespace :cell_sites do
  namespace :import do
    task :email => :environment do
      config = YAML::load(File.open("#{RAILS_ROOT}/config/mail.yml"))
      EmailMessage.connect(config['imap'])
      
      if RAILS_ENV == 'development'
        EmailMessage.set_mailbox('processed')
      end
      
      EmailSubmission.all.each do |email_submission| 
        if email_submission.save
          puts "#{email_submission.message_id} SAVED"
          if email_submission.cell_site.creator.active?
            puts "thank you active user!"
            CellSiteSubmissionMailer.deliver_valid_known_user!(email_submission)
          else
            puts "inactive user!"
            CellSiteSubmissionMailer.deliver_valid_unknown_user!(email_submission)
          end
        else
          puts "#{email_submission.message_id} INVALID: #{email_submission.errors}"
          CellSiteSubmissionMailer.deliver_invalid!(email_submission)
        end
      end
      
      EmailMessage.expunge
    end
  end
end