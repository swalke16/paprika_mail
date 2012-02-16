module PaprikaMail::Models

  class RecipeAttribute
    attr_accessor :name
    attr_accessor :value

    def initialize(name, value)
      @name = name
      @value = value
    end
  end

end

