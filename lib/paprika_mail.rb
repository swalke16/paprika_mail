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
    @log.debug(message)
  end

  def self.blog_url
    config["blog"]["url"]
  end

  def self.blog_service_name
    config["blog"]["service"]
  end

  def self.blog_service
    @blog_service ||= BlogService.new(config["blog"])
  end

  private

  def self.config
    @config ||= YAML.load_file("#{CONFIG_PATH}/paprika_mail.config")
  end
end

require_rel 'paprika_mail/models'
require_rel 'paprika_mail/parsers'
require_rel 'paprika_mail/renderer'
require_rel "paprika_mail/#{PaprikaMail.blog_service_name.downcase}"

