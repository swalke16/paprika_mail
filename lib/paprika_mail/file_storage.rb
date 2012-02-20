require 'aws/s3'

module PaprikaMail

  class FileStorage

    def initialize(cfg)
      @cfg = cfg
      @connection = ::AWS::S3::Base.establish_connection!(
        :access_key_id => cfg["access_key_id"],
        :secret_access_key => cfg["secret_access_key"]
      )
    end

    def store(name, file)
      resp = AWS::S3::S3Object.store(
        name,
        File.open(file),
        @cfg["bucket"],
        :access => :public_read
      )

      if !resp.error?
        AWS::S3::S3Object.find(name, @cfg["bucket"]).url(:authenticated => false)
      else
        resp.error
      end
    end

  end

end
