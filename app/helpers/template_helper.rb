module TemplateHelper
  def add_template(options={})
    content_for :templates do 
      if options[:partial]
        render options
      else
        content = yield
        content
      end
    end
  end
end