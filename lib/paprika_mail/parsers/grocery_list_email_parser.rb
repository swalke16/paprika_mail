module PaprikaMail::Parsers

  class GroceryListEmailParser < EmailParser

    def parse
      grocery_list = PaprikaMail::Models::GroceryList.new(*parse_date_range)
      mail_text_body.scan(/Aisle:\s+([\w\s,]+)(- .*?)(?=Aisle:|Sent)/mi) do |aisle, items|
        items.lines.reject {|line| line.chomp.length == 0}.each do |item|
          grocery_list.add_item(aisle.strip, item.gsub(/-/,'').strip)
        end
      end
      grocery_list
    end

  end

end
