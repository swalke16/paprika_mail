$: << File.expand_path(File.dirname(__FILE__)) + '/lib'

require 'rubygems'
require 'logger'
require 'mail'
require 'yaml'
require 'paprika_mail'

message = $stdin.read
# #log.debug message
mail = Mail.new(message)

parser = PaprikaMail::Parsers::GroceryListEmailParser.create(mail).parse
puts parser.inspect


require 'haml'
require 'tilt'

presenter = PaprikaMail::GroceryListPresenter.new(parser)

template = Tilt::HamlTemplate.new('views/grocery_list.haml')
puts template.render(presenter)
