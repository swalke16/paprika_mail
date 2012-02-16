require 'delegate'

module PaprikaMail

  class MealPlanPresenter < SimpleDelegator

    def grocery_list_url
      "#{PaprikaMail.blog_url}/grocery-list-#{start_date.strftime("%m%d%y")}-#{end_date.strftime("%m%d%y")}"
    end

    def recipe_url(name)
      PaprikaMail.blog_url + "/" + name.gsub(/[^a-z!#$&?;=~\-_\[\] ]+/i, '').gsub(/ /, '-').downcase
    end

  end

end
