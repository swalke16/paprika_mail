# root_dir = File.expand_path(File.dirname(__FILE__))
# $: << "#{root_dir}/lib"
#
# require 'rubygems'
# require 'logger'
# require 'mail'
# require 'yaml'
# require  "#{root_dir}/mail_builder.rb"
#
# aws_ses_config = YAML.load_file("#{root_dir}/conf/aws_ses.config")
# Mail.defaults do
#   delivery_method :smtp, {
#                   :address => aws_ses_config["address"],
#                   :port => aws_ses_config["port"],
#                   :tls => true,
#                   :user_name => aws_ses_config["user_name"],
#                   :password => aws_ses_config["password"] }
# end
#
# log = Logger.new("#{root_dir}/logs/paprika_mail_log", 10, 102400)
# log.level = Logger::DEBUG
#
# message = $stdin.read
# #log.debug message
# mail = Mail.new(message)
#
# #do email formatting stuff
# mail = MailBuilder.new(mail).build()
# log.debug(mail.to_s)
#
# #send email through AWS SES
# begin
#   mail.deliver!
# rescue Exception => e
#   log.error(e.to_s)
# end
