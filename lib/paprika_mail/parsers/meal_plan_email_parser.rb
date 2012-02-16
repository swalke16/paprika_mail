module PaprikaMail::Parsers

  class MealPlanEmailParser < EmailParser

    def parse
      meal_plan = PaprikaMail::Models::MealPlan.new(*parse_date_range)
      mail_text_body.scan(/(Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday), ([\w, ]+)(.*?)(?=Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sent)/mi) do |day, date, meals|
        meals.strip.lines.reject{|line| line.chomp.length == 0}.each {|meal| meal_plan.add_meal(day.strip, *parse_meal(meal))}
      end
      meal_plan
    end

    private

    def parse_meal(meal_string)
      meal_string.strip.scan(/^(\w+):\s(.+)$/).flatten
    end

  end

end
