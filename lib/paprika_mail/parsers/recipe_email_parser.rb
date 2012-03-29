require 'uri'
require 'base64'
require 'json'
require 'zlib'

module PaprikaMail::Parsers

  class RecipeEmailParser < EmailParser

    def parse
      load_recipe_json
      recipe = PaprikaMail::Models::Recipe.new
      recipe.name = parse_name
      parse_cooking_info.each { |name, value| recipe.send("#{name.gsub(/ /, '_').downcase}=", value) }
      recipe.directions.concat parse_directions
      recipe.source, recipe.source_url = parse_source
      recipe.ingredients.concat parse_ingredients
      image = parse_image
      recipe.add_image(*image)
      recipe.add_media(*paprika_recipe)
      recipe
    end

    private

    def load_recipe_json
      gz = Zlib::GzipReader.new(paprika_recipe[1].open)
      @recipe = JSON.parse(gz.read)
    end

    def parse_name
      @recipe["name"]
    end

    def parse_cooking_info
      cooking_info = {
        "Cook Time" => @recipe["cook_time"],
        "Prep Time" => @recipe["prep_time"],
        "Servings" => @recipe["servings"],
        "Difficulty" => @recipe["difficulty"],
        "Rating" => @recipe["rating"],
        "Nutritional Info" => @recipe["nutritional_info"]
      }
    end

    def parse_source
      source = [nil, nil]

      begin
        uri = URI(@recipe["source_url"])
        source = [@recipe["source"], uri.to_s]
      rescue URI::InvalidURIError => e
        source = [@recipe["source"], nil]
      end

      source
    end

    def parse_directions
      @recipe["directions"].lines.reject {|line| line.chomp.length == 0}.map {|item| item.strip.gsub(/^-/,'').gsub(/\d+\.?/,'').strip}
    end

    def parse_ingredients
      @recipe["ingredients"].lines.reject {|line| line.chomp.length == 0}.map {|item| item.strip.gsub(/^-/,'').strip}
    end

    def parse_image
      if @recipe["photo"]
        img_ext = File.extname @recipe["photo"]
        img_data = Base64.decode64 @recipe["photo_data"]

        Tempfile.open(["recipe_photo", img_ext]) do |f|
          f.write(img_data)
          ["#{parse_name}#{img_ext}", f]
        end
      else
        [nil, nil]
      end
    end

    def paprika_recipe
      paprika_recipe = []

      name = @mail.subject.gsub(/Recipe: /, '')
      ext = "paprikarecipe"

      throw "Mail recipe attachment is hosed!" if @mail.attachments.count == 0

      @mail.attachments.each do |attachment|
        if attachment.content_type =~ /#{ext}/
          Tempfile.open([name, ".#{ext}"]) do |f|
            f.write(attachment.body.decoded)
            paprika_recipe << "#{name}.#{ext}" << f
          end
        end
      end

      paprika_recipe
    end

  end

end
