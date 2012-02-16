module PaprikaMail::Models

  class Recipe
    attr_accessor :name
    attr_reader :attributes
    attr_reader :ingredients
    attr_reader :directions
    attr_accessor :source
    attr_accessor :image

    def initialize
      @attributes = []
      @ingredients = []
      @directions = []
    end

    def add_attribute(name, value)
      @attributes << RecipeAttribute.new(name, value)
    end
  end

end
