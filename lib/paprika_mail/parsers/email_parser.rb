module PaprikaMail::Parsers
  class EmailParser
    def initialize(mail)
      @mail = mail
      @attrs = {}
      parse_date_range
      parse_content
    end

    def method_missing(m, *args, &block)
      return @attrs[m] if @attrs.has_key?(m)
      super
    end

    def respond_to?(m)
      return true if @attrs.has_key?(m)
      super
    end

    private

    def mail_text_body
      @mail_text_body ||= @mail.text_part.body.to_s
    end

    def mail_html_body
      @mail_html_body ||= @mail.html_part.body.to_s
    end

    def parse_date_range
      # matches dates in month/day/year format and captures them
      date_range = @mail.subject.scan(/(\d{1,2}\/\d{1,2}\/\d{2,4})/).flatten
      @attrs[:start_date] = date_range[0]
      @attrs[:end_date] = date_range[1]
    end
  end
end
