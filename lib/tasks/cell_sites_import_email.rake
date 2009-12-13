namespace :cell_sites do
  namespace :import do
    task :email => :environment do
      config = YAML::load(File.open("#{RAILS_ROOT}/config/mail.yml"))
      EmailMessage.connect(config['imap'])
    
      EmailSubmission.all.each do |email_submission| 
        if email_submission.save
          puts "#{email_submission.message_id} SAVED"
          if email_submission.cell_site.creator.active?
            puts "thank you active user!"
          else
            puts "inactive user!"
          end
        else
          puts "#{email_submission.message_id} INVALID: #{email_submission.errors}"
          # send error email
        end
      end
      
      EmailMessage.expunge
    end
  end
end