require 'base64'

module PaprikaMail::Parsers

  class RecipeEmailParser < EmailParser

    def parse
      recipe = PaprikaMail::Models::Recipe.new
      recipe.name = @mail.subject.gsub(/Recipe: /, '')
      parse_cooking_info.each { |name, value| recipe.add_attribute(name, value) }
      recipe.directions.concat parse_directions
      recipe.source = parse_source
      recipe.ingredients.concat parse_ingredients
      recipe.image = parse_image
      recipe
    end

    private

    def parse_cooking_info
      cooking_info = {}

      mail_text_body.scan(/^(\*(?!Source).*?)(?=Ingredient)/im) do |meta|
        meta[0].gsub(/\n/, '').split(' | ').map do |item|
          item.scan(/\*([\w\s]+):\*\s+([\w-]+)/) do |name, value|
            cooking_info[name] = value
          end
        end
      end

      cooking_info
    end

    def parse_source
      source = nil
      mail_text_body.scan(/^\*Source:\*$\W(.*)$/) {|source_url| source = source_url[0]}
      source
    end

    def parse_directions
      directions = []

      mail_text_body.scan(/^(?>Directions:)(.*?)(?=\*Source)/m) do |match|
        lines = match[0].strip.lines.to_a
        lines.each_with_index do |line, i|
          next if line.strip.length == 0
          next if i > 0 && lines[i-1].strip.length > 0

          if i < lines.count - 1
            line = "#{line.strip} #{lines[i+1]}" unless lines[i+1].match(/^\\n/)
          end

          directions << line.gsub(/^\d+\./, '').strip
        end
      end

      directions
    end

    def parse_ingredients
      ingredients = []

      mail_text_body.scan(/Ingredients:\W+(.*?)(?=Directions)/mi) do |match|
        ingredients = match[0].lines.reject {|line| line.chomp.length == 0}.map {|item| item.gsub(/-/,'').strip}
      end

      ingredients
    end

    def parse_image
      image = {}
      img_data = mail_html_body.match(/<img src="(.*?)">/m)
      if img_data
        img_data = img_data[1]
        image[:data] = Base64.decode64(img_data.gsub(/data:image\/([\w|-]+);base64,/) do |image_info|
          image[:extension] = $1
          ""
        end)
      end
      image
    end

    # find the .paprikarecipe attachment and pass it along
    # TODO: amazon won't let us send this. use s3? or support hrecipe
    # @src_mail.parts.each do |part|
    #   if (part.content_type =~ /application\/paprikarecipe/)
    #     @mail.add_part(part)
    #   end
    # end

  end

end
