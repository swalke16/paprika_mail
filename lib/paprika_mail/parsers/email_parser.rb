module PaprikaMail::Parsers
  class EmailParser
    attr_reader :attrs

    def initialize(mail)
      @mail = mail
      @attrs = {}
      parse_date_range
      parse_content
    end

    def self.create(mail)
      return MealPlanEmailParser.new(mail) if mail.subject =~ /Meal Plan/
      return GroceryListEmailParser.new(mail) if mail.subject =~ /Grocery List/
      return RecipeEmailParser.new(mail) if mail.subject =~ /Recipe/
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
