module PaprikaMail::Models

  class MealPlan
    attr_reader :start_date
    attr_reader :end_date

    Date::DAYNAMES.each do |day|
      attr_reader day.to_sym
    end

    def initialize(start_date, end_date)
      @start_date = start_date
      @end_date = end_date

      Date::DAYNAMES.each do |day|
        instance_variable_set "@#{day}", []
      end
    end

    def add_meal(day, name, recipe)
      send(day.to_sym) << Meal.new(name, recipe)
    end
  end

end

