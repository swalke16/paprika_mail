require 'require_all'
require 'yaml'

module PaprikaMail
  CONFIG_PATH = File.expand_path(File.dirname(__FILE__) + "/../config")

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
require_rel "paprika_mail/#{PaprikaMail.blog_service_name.downcase}"
