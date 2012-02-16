require 'yaml'

module PaprikaMail::Config

  class Posterous
    attr_reader :api_token
    attr_reader :username
    attr_reader :password

    def initialize
      cfg = YAML.load_file("#{PaprikaMail::CONFIG_PATH}/posterous.config")

      @api_token = cfg["api_token"]
      @username = cfg["username"]
      @password = cfg["password"]
    end

  end

end
