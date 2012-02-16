module PaprikaMail::Models

  class Meal
    attr_accessor :name
    attr_accessor :recipe

    def initialize(name, recipe)
      @name = name
      @recipe = recipe
    end
  end

end

