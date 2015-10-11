require 'ostruct'

module Thunderbird
  class SelectResult
    attr_reader :rows

    def initialize(db:, query:)
      @db = db
      @query = query
      @rows = @db.execute2(@query)
      @columns = @rows.shift
      @rows = @rows.map { |r| map_row_to_hash(r) }
    end

    private

    def map_row_to_hash(row)
      data = OpenStruct.new
      row.each_with_index do |content, index|
        data[@columns[index]] = content
      end
      data
    end
  end
end
