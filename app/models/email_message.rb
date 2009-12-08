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
    
    @connection = Net::IMAP.new(options[:server])         # 'imap.emailsrvr.com'
    @connection.login(options[:user], options[:password]) # 'submit@allyourcells.com', 'bucksaw8poseur'
    @connection.select('Inbox')
  end
  
  def self.connection
    @connection
  end
  
  def self.all(conditions = [])
    if conditions.blank?
      conditions = ["SINCE", "1-Jan-1969"]
    end
    raw_messages = connection.search(conditions)
    
    raw_messages.map{ |raw_msg| new(raw_msg) }
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
  
  private
  
  def message
    connection.fetch(@message_id, ["ENVELOPE", "UID","BODY"] )[0]
  end
  memoize :message
  
  def connection
    self.class.connection
  end
end