module PaprikaMail::Models

  class GroceryList
    attr_reader :start_date
    attr_reader :end_date
    attr_reader :aisles

    def initialize(start_date, end_date)
      @start_date = start_date
      @end_date = end_date
      @aisles = {}
    end

    def add_item(aisle, item)
      @aisles[aisle] = [] unless @aisles.has_key? aisle
      @aisles[aisle] << item
    end
  end

end


