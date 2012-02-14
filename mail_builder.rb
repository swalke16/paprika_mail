require 'rubygems'
require 'mail'
require 'redcarpet'
require 'base64'

#TODO: hRecipe classes

class MailBuilder
  BLOG_URL_ROOT = 'http://www.fitpaleofamily.com/'

  def initialize(mail)
    @src_mail = mail
    @mail = Mail.new do
      from 'swalke16@gmail.com'
      to 'fitpaleofamily@posterous.com'
    end
  end

  def build()
    return build_grocery_list_mail if grocery_list?
    return build_meal_plan_mail if meal_plan?
    return build_recipe_mail if recipe?
  end

  def build_grocery_list_mail
    body = mail_text_body
    body = body.gsub(/Grocery List/, '')
    body = "[Meal Plan](#{meal_plan_url})\r\n\r\n" + body
    body = body.gsub(/^Aisle: /, '###')
    body = strip_attributions(body)

    @mail.html_part = Mail::Part.new do
      content_type 'text/html; charset=UTF-8'
      body Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(body)
    end

    date_range = mail_date_range
    @mail.subject = "Grocery List #{date_range[0]} - #{date_range[1]}#{tags("grocerylist")}"
    @mail
  end

  def build_meal_plan_mail
    body = mail_text_body
    body = body.gsub(/Meal plan .*:/, '')
    body = "[Grocery List](#{grocery_list_url})\r\n\r\n" + body
    body = body.gsub(/^((?:Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday).*)$/, '###\1')
    body = body.gsub(/^(\w+:)\s(.+)$/) do |meal|
      meal.gsub(/#{$1}\s#{$2}/, "**#{$1}** [#{$2}](#{recipe_url($2)})")
    end

    body = strip_attributions(body)

    @mail.html_part = Mail::Part.new do
      content_type 'text/html; charset=UTF-8'
      body Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(body)
    end

    date_range = mail_date_range
    @mail.subject = "Meal Plan #{date_range[0]} - #{date_range[1]}#{tags("mealplan")}"
    @mail
  end

  def build_recipe_mail
    recipe_name = @src_mail.subject.gsub(/Recipe: /, '')

    body = mail_text_body
    body = body.gsub(/^#{recipe_name}$/, '') # remove recipe name in body
    body = body.gsub(/^\*(?!Source).*$/i) do |meta| # transform prep time, cook time, etc... line
      cooking_info = meta.split(' | ').map do |item|
        item.gsub(/\*([\w\s]+):\*\s+([\w\s-]+)/, '**\1** \2  ')
      end.join("\r\n")
      "###Cooking Info\r\n" + cooking_info + "\r\n"
    end

    body = body.gsub(/^Directions:(.*)(?=\*Source)/m) do |directions|
      lines = []
      directions.strip.each_line do |line|
        lines << "#{(lines.count + 1).to_s}. #{line.gsub(/^\d+\./, '')}" if line.strip.length > 0
      end
      "###Directions\r\n" + lines.join("") + "\r\n\r\n"
    end

    body = body.gsub(/^\*Source:\*$\W(.*)$/, "###Source:\r\n[\\1](\\1)  ")
    body = body.gsub(/^(Ingredients:)$/, '###\1')
    body = strip_attributions(body)

    # find the image and convert to attachment and link
    img_data = @src_mail.html_part.body.to_s.match(/<img src="(.*?)">/m)
    if img_data
      img_ext = "png"
      img_data = img_data[1]
      img_data = img_data.gsub(/data:image\/([\w|-]+);base64,/) do |image_info|
        img_ext = $1
        ""
      end
      @mail.attachments["photo.#{img_ext}"] = Base64.decode64(img_data)

      body = "![#{recipe_name}](#{@mail.attachments.last.url})  \r\n\r\n" + body
    end

    # find the .paprikarecipe attachment and pass it along
    # TODO: amazon won't let us send this. use s3? or support hrecipe
    # @src_mail.parts.each do |part|
    #   if (part.content_type =~ /application\/paprikarecipe/)
    #     @mail.add_part(part)
    #   end
    # end

    @mail.html_part = Mail::Part.new do
      content_type 'text/html; charset=UTF-8'
      body Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(body)
    end

    #TODO: tag recipes based on categories (currently not available)
    @mail.subject = "#{recipe_name}#{tags("recipe")}"
    @mail
  end

  private

  def meal_plan?
    @src_mail.subject =~ /Meal Plan/
  end

  def grocery_list?
    @src_mail.subject =~ /Grocery List/
  end

  def recipe?
    @src_mail.subject =~ /Recipe/
  end

  def meal_plan_url
    date_range = mail_date_range.map { |date| date.gsub(/\//, "") }
    "#{BLOG_URL_ROOT}meal-plan-#{date_range[0]}-#{date_range[1]}"
  end

  def grocery_list_url
    date_range = mail_date_range.map { |date| date.gsub(/\//, "") }
    "#{BLOG_URL_ROOT}grocery-list-#{date_range[0]}-#{date_range[1]}"
  end

  def recipe_url(name)
    BLOG_URL_ROOT + name.gsub(/[^a-z!#$&?;=~\-_\[\] ]+/i, '').gsub(/ /, '-').downcase
  end

  def strip_attributions(body)
    body.gsub(/^Sent from .*$/, '')
  end

  def mail_text_body
    @src_mail.text_part.body.to_s
  end

  def mail_date_range
    # matches dates in month/day/year format and captures them
    @src_mail.subject.scan(/(\d{1,2}\/\d{1,2}\/\d{2,4})/).flatten
  end

  def tags(*tags)
    " ((tag: #{tags.join(", ")}))"
  end
end
