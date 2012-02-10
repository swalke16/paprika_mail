require 'rubygems'
require 'mail'

# TODO:
# tag based on categories...
#body = "<img src='cid:#{}'>" + body

class MailBuilder
  BLOG_URL_ROOT = 'http://www.fitpaleofamily.com/'
  GROCERY_LIST_EMAIL_PATTERN = /Grocery List/
  DATE_RANGE_PATTERN = /(\d{1,2}\/\d{1,2}\/\d{2,4})/ # matches dates in month/day/year format and captures them

  def format(mail)
    body = mail.body.parts.text_part.body
    body = format_grocery_list(mail.subject, body) if (mail.subject =~ GROCERY_LIST_EMAIL_PATTERN)

    mail.body = body
  end

  def format_grocery_list(subject, body)
    list_date_range = subject.match DATE_RANGE_PATTERN

    body = "[Meal Plan](#{meal_plan_url(list_date_range)})"  + body
    body = body.gsub(/Grocery List/, '')
    body = body.gsub(/^Aisle: /, '###')

    strip_attributions(body)
  end

  private

  def meal_plan_url(date_range)
    date_range = date_range.map { |date| date.gsub(/\//, "") }
    "#{BLOG_URL_ROOT}/meal-plan-#{date_ranage[0]}-#{date_range[1]}"
  end

  def strip_attributions(body)
    body.gsub(/^Sent from .*$/, '')
  end
end
