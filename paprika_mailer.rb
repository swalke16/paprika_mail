$: << File.expand_path(File.dirname(__FILE__)) + '/lib'

require 'rubygems'
require 'logger'
require 'mail'
require 'yaml'
require 'paprika_mail'

message = $stdin.read
# #log.debug message
mail = Mail.new(message)

#parser = PaprikaMail::Parsers::EmailParser.create(mail)
#puts parser.attrs[:recipe].inspect

poster = PaprikaMail::Posters::Posterous.new("fitpaleofamily")
poster.create(:title => 'Test Post', :body => 'Test Post Body')
puts poster.inspect

