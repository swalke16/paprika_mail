require 'require_all'

module PaprikaMail
  CONFIG_PATH = File.expand_path(File.dirname(__FILE__) + "/../conf")
end

require_rel 'paprika_mail'
