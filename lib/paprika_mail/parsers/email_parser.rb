require 'mail'

module PaprikaMail::Parsers
  class EmailParser
    attr_reader :attrs

    def initialize(mail)
      @mail = mail
    end

    def self.create(mail_string)
      mail = Mail.new(mail_string)
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
      dates = @mail.subject.scan(/(\d{1,2}\/\d{1,2}\/\d{2,4})/).flatten.map{|date| Date.strptime(date, '%m/%d/%y') }
      if !dates || dates.length < 2
        infer_date_range Date.today
      else
        dates
      end
    end

    def infer_date_range(today)
      day_of_week = today.wday

      if day_of_week == 0 #sunday
        start_date = today
      else
        days_till_next_week = 7 - day_of_week
        start_date = today + days_till_next_week
      end

      end_date = start_date + 6
      [start_date, end_date]
    end
  end
end
