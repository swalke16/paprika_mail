module PaprikaMail::Models

  class Attachment
    attr_reader :url
    attr_reader :filename

    def initialize(filename, file)
      @filename = filename
      if file.is_a?(String)
        @file = File.open(file)
      else
        @file = file
      end

      @url = PaprikaMail.file_storage.store(filename, @file)
    end

    def extension
      File.extname(@filename)
    end

    def basename
      File.basename(@filename, extension)
    end

    def local_path
      @file ? file.path : nil
    end

  end

end

