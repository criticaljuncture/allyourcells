# Refactor me out into a plugin...
module PaperclipValidateUniqueness
  module Paperclip
    module Attachment
      require 'digest/md5'
      def md5_hash
        Digest::SHA256.file(@queued_for_write[:original].path).hexdigest
      end
      def validate_uniqueness options
        if file?
          hash = md5_hash
          identical_instances = instance.class.scoped(:conditions => {"#{name}_md5_hash" => hash})
          if instance.id
            identical_instances = identical_instances.scoped(:conditions => ["id != ?", instance.id])
          end
          instance_write(:md5_hash, hash)
        
          if identical_instances.count > 0
            options[:message]
          end
        end
      end
    end
    
    module ClassMethods
      # Places ActiveRecord-style validations on the uniqueness of a file.
      # Options:
      # * +if+: A lambda or name of a method on the instance. Validation will only
      #   be run is this lambda or method returns true.
      # * +unless+: Same as +if+ but validates if lambda or method returns false.
      def validates_attachment_uniqueness name, options = {}
        message = options[:message] || "must be unique."
        attachment_definitions[name][:validations] << [:uniqueness, {:message => message,
                                                                   :if      => options[:if],
                                                                   :unless  => options[:unless]}]
      end
    end
  end
end
Paperclip::Attachment.send(:include, PaperclipValidateUniqueness::Paperclip::Attachment)
ActiveRecord::Base.send(:extend, PaperclipValidateUniqueness::Paperclip::ClassMethods)