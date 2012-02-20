require 'require_all'
require 'yaml'
require 'logger'

module PaprikaMail
  CONFIG_PATH = File.expand_path(File.dirname(__FILE__) + "/../config")
  LOG_PATH = File.expand_path(File.dirname(__FILE__) + "/../logs")

  def self.log(message)
    unless @log
      @log ||= Logger.new("#{LOG_PATH}/paprika_mail_log", 10, 102400)
      @log.level = Logger::DEBUG
    end
    @log.debug(message_for(message))
  end

  def self.blog_url
    config["blog_service"]["url"]
  end

  def self.blog_service_name
    config["blog_service"]["service"]
  end

  def self.blog_service
    @blog_service ||= BlogService.new(config["blog_service"])
  end

  def self.file_storage
    @file_storage ||= PaprikaMail::FileStorage.new(config["file_storage"])
  end

  private

  def self.config
    @config ||= YAML.load_file("#{CONFIG_PATH}/paprika_mail.config")
  end

  def self.message_for(obj)
    if obj.is_a? Exception
      obj = "\n\n#{obj.class} (#{obj.message}):\n    " +
              obj.backtrace.join("\n    ") +
              "\n\n"
    end

    obj
  end
end

require_rel 'paprika_mail/models'
require_rel 'paprika_mail/parsers'
require_rel 'paprika_mail/renderer'
require_rel 'paprika_mail/file_storage'
require_rel "paprika_mail/#{PaprikaMail.blog_service_name.downcase}"

