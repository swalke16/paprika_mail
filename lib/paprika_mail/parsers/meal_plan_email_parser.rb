module PaprikaMail::Parsers

  class MealPlanEmailParser < EmailParser

    private

    def parse_content
      days = {}
      mail_text_body.scan(/(Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday), ([\w, ]+)(.*?)(?=Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sent)/mi) do |day, date, meals|
        days[day.strip] = {
          :date => date.strip,
          :meals => meals.strip.lines.reject{|line| line.chomp.length == 0}.map {|meal| parse_meal(meal)}
        }
      end
      @attrs[:days] = days
    end

    def parse_meal(meal_string)
      meal = {}
      meal_string.strip.scan(/^(\w+):\s(.+)$/) do |name, recipe|
        meal[:name] = name
        meal[:recipe] = recipe
      end
      meal
    end

  end

end
