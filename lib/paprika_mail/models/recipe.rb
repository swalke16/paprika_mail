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
    attr_accessor :source_url
    attr_reader :image
    attr_reader :media

    def initialize
      @attributes = []
      @ingredients = []
      @directions = []
      @media = []
    end

    def add_image(filename, file)
      @image = PaprikaMail::Models::Attachment.new(filename, file)
    end

    def add_media(filename, file)
      attachment = PaprikaMail::Models::Attachment.new(filename, file)
      @media << attachment
      attachment
    end

  end

end
