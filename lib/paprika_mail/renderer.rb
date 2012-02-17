require 'haml'
require 'tilt'

module PaprikaMail

  class Renderer

    def self.render(obj)
      context = view_context(obj)
      template = Tilt::HamlTemplate.new("views/#{template_name_for(obj)}.haml")
      template.render(context)
    end

    private

    def self.bare_class_name(obj)
      obj.class.name.split("::").last
    end

    def self.view_context(obj)
      presenter_class = get_class("PaprikaMail::#{bare_class_name(obj)}Presenter")
      presenter_class.is_a?(Class) ? presenter_class.new(obj) : obj
    end

    def self.template_name_for(obj)
      bare_class_name(obj).gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

    def self.get_class(class_name)
      begin
       return class_name.split('::').inject(Object) { |k,n| k.const_get n }
      rescue
        return class_name
      end
    end
  end

end

