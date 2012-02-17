module PaprikaMail::Models

  class Recipe
    attr_accessor :name
    attr_accessor :prep_time
    attr_accessor :cook_time
    attr_accessor :servings
    attr_accessor :difficulty
    attr_reader :ingredients
    attr_reader :directions
    attr_accessor :source
    attr_reader :image
    attr_reader :media

    def initialize
      @attributes = []
      @ingredients = []
      @directions = []
      @media = []
    end

    def add_image(filename)
      @image = add_media(filename)
    end

    def add_media(filename)
      file = filename.is_a?(String) ? File.open(filename) : filename
      @media << file
      file
    end

  end

end
