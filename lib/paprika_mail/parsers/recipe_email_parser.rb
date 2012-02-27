require 'base64'

module PaprikaMail::Parsers

  class RecipeEmailParser < EmailParser

    def parse
      recipe = PaprikaMail::Models::Recipe.new
      recipe.name = parse_name
      parse_cooking_info.each { |name, value| recipe.send("#{name.gsub(/ /, '_').downcase}=", value) }
      recipe.directions.concat parse_directions
      recipe.source = parse_source
      recipe.ingredients.concat parse_ingredients
      image = parse_image
      recipe.add_image *image if image
      parse_attachments.each { |file| recipe.add_media(*file) }
      recipe
    end

    private

    def parse_name
      @mail.subject.gsub(/Recipe: /, '')
    end

    def parse_cooking_info
      cooking_info = {}

      mail_text_body.scan(/^(\*(?!Source).*?)(?=Ingredient)/im) do |meta|
        meta[0].gsub(/\n/, '').split(' | ').map do |item|
          item.scan(/\*([\w\s]+):\*\s*(.+)/) do |name, value|
            cooking_info[name.strip] = value.strip
          end
        end
      end

      cooking_info
    end

    def parse_source
      source = nil
      mail_text_body.scan(/^\*Source:\*\W(.*)$/) {|source_url| source = source_url[0]}
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
        ingredients = match[0].lines.reject {|line| line.chomp.length == 0}.map {|item| item.strip.gsub(/^-/,'').strip}
      end

      ingredients
    end

    def parse_image
      img_ext = 'png'
      img_data = mail_html_body.match(/<img src="(.*?)">/m)
      if img_data
        img_data = img_data[1]
        img_data = Base64.decode64(img_data.gsub(/data:image\/([\w|-]+);base64,/) do |image_info|
          img_ext = ".#{$1}"
          ""
        end)

        Tempfile.open(["recipe_photo", img_ext]) do |f|
          f.write(img_data)
          ["#{parse_name}#{img_ext}", f]
        end
      end
    end

    def parse_attachments
      attachments = []

      #TODO: somtimes paprika fubars the filenames... WTF!??!!?

      @mail.attachments.each do |attachment|
        extension = File.extname(attachment.filename)
        name = File.basename(attachment.filename).gsub(/#{extension}/, "")
        attachments << Tempfile.open([name, extension]) do |f|
          f.write(attachment.body.decoded)
          ["#{name}#{extension}", f]
        end
      end

      attachments
    end

  end

end
