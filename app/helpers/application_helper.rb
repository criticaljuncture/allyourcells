# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(text, options = {})
    options.symbolize_keys!
    
    content_for :title, text
    unless options[:body] == false
      content_for :precolumn, content_tag(:h1, text, :class => 'topinfo')
    end
  end
  def alert_exclamation
    choices = ["AHOY", "GOLLY", "WELL DONE", "TALLY HO", "GEE WHIZ", "SPLENDIFEROUS", "YEEHAW", "BOOYAH"]
    choices[rand(choices.length)] 
  end  
  def error_exclamation
    choices = ["SCHNIKES", "JINKIES", "EGAD", "OH DEAR", "GOOD GRIEF", "ZOINKS", "AHEM", "GEE WILLIKERS"]
    choices[rand(choices.length)] 
  end
end
