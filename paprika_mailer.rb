$: << File.expand_path(File.dirname(__FILE__)) + '/lib'

require 'rubygems'
require 'logger'
require 'yaml'
require 'paprika_mail'

mail = $stdin.read

begin
  model = PaprikaMail::Parsers::EmailParser.create(mail).parse
  PaprikaMail.blog_service.create(model)
rescue Exception => e
  PaprikaMail.log(e.to_s)
end

