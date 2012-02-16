require 'delegate'

module PaprikaMail

  class GroceryListPresenter < SimpleDelegator

    def meal_plan_url
      "#{PaprikaMail.blog_url}/meal-plan-#{start_date.strftime("%m%d%y")}-#{end_date.strftime("%m%d%y")}"
    end

  end

end
