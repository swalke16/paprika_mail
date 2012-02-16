module PaprikaMail::Parsers
  class EmailParser
    attr_reader :attrs

    def initialize(mail)
      @mail = mail
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
      @mail.subject.scan(/(\d{1,2}\/\d{1,2}\/\d{2,4})/).flatten.map{|date| Date.strptime(date, '%m/%d/%y') }
    end
  end
end
