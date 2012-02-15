module PaprikaMail::Parsers

  class GroceryListEmailParser < EmailParser

    private

    def parse_content
      aisles = {}
      mail_text_body.scan(/Aisle:\s+([\w\s,]+)(- .*?)(?=Aisle:|Sent)/mi) do |aisle, items|
        aisles[aisle.strip] = items.lines.reject {|line| line.chomp.length == 0}.map {|item| item.gsub(/-/,'').strip}
      end
      @attrs[:aisles] = aisles
    end

  end

end
