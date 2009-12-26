# see http://groups.google.com/group/comp.lang.ruby/msg/035581d6c60034be
class EmailMessage
  class Part
    def initialize(message_id, raw_part, index)
      @message_id = message_id
      @raw_part = raw_part
      @index = index
    end
    
    delegate :media_type, :subtype, :to => :raw_part
    
    def content
      EmailMessage.connection.fetch(@message_id, "BODY[#{@index+1}]")[0].attr["BODY[#{@index+1}]"]
    end
    
    protected
    
    def raw_part
      @raw_part
    end
  end
  
  extend ActiveSupport::Memoizable
  attr_accessor :message_id
  
  def self.connect(options)
    options.symbolize_keys!
    
    @connection = Net::IMAP.new(options[:address])
    @connection.login(options[:user_name], options[:password]) 
    
    set_mailbox('Inbox')
  end
  
  def self.set_mailbox(mailbox)
    @connection.select(mailbox)
  end
  
  def self.connection
    @connection
  end
  
  def self.all(conditions = [])
    if conditions.blank?
      conditions = ["SINCE", "1-Jan-1969"]
    end
    raw_messages = EmailMessage.connection.search(conditions)
    
    raw_messages.map{ |raw_msg| new(raw_msg) }
  end
  
  def self.expunge
    connection.expunge
  end
  
  def initialize(message_id)
    @message_id = message_id
  end
  
  def parts
    parts = []
    message.attr["BODY"].parts.each_with_index do |raw_part, i|
      parts << Part.new(message_id, raw_part, i)
    end
    parts
  end
  memoize :parts
  
  def uid
    message.attr["UID"]
  end
  
  def subject
    message.attr["ENVELOPE"].subject
  end
  
  def sender
     message.attr["ENVELOPE"].from.first
  end
  
  def sender_email
    "#{sender.mailbox}@#{sender.host}"
  end
  
  def move_to(folder)
    EmailMessage.connection.copy(message_id, folder)
    EmailMessage.connection.store(message_id, "+FLAGS", [:Deleted])
  end
  
  private
  
  def message
    EmailMessage.connection.fetch(@message_id, ["ENVELOPE", "UID","BODY"] )[0]
  end
  memoize :message
end