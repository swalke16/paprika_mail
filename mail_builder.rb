require 'rubygems'
require 'mail'
require 'redcarpet'

# TODO:
# tag based on categories...
#body = "<img src='cid:#{}'>" + body

class MailBuilder
  BLOG_URL_ROOT = 'http://www.fitpaleofamily.com/'
  GROCERY_LIST_EMAIL_PATTERN = /Grocery List/
  DATE_RANGE_PATTERN = /(\d{1,2}\/\d{1,2}\/\d{2,4})/ # matches dates in month/day/year format and captures them

  def initialize(mail)
    @src_mail = mail
    @mail = Mail.new do
      from 'swalke16@gmail.com'
      to 'fitpaleofamily@posterous.com'
    end
  end

  def build()
    build_grocery_list_mail if (@src_mail.subject =~ GROCERY_LIST_EMAIL_PATTERN)

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

  private

  def meal_plan_url
    date_range = mail_date_range.map { |date| date.gsub(/\//, "") }
    "#{BLOG_URL_ROOT}meal-plan-#{date_range[0]}-#{date_range[1]}"
  end

  def strip_attributions(body)
    body.gsub(/^Sent from .*$/, '')
  end

  def mail_text_body
    @src_mail.text_part.body.to_s
  end

  def mail_date_range
    @src_mail.subject.scan(DATE_RANGE_PATTERN).flatten
  end

  def tags(*tags)
    " ((tag: #{tags.join(", ")}))"
  end
end
