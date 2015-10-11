#!/usr/bin/env ruby

require 'sqlite3'
require 'ostruct'
require 'pry'

class Thunderbird
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

  def initialize
    @db = SQLite3::Database.new('global-messages-db.sqlite')
    set_mozport_tokenizer!
  end

  def self.search(query)
    new.search(query)
  end

  def search(query)
    results = SelectResult.new(db: @db, query: "select * from messagesText")
    matches = results.rows.select do |row|
      row_matches_query?(row, query)
    end
  end

  private

  def content_matches_query?(content, query)
    content && content.include?(query)
  end

  def row_matches_query?(row, query)
    return true if content_matches_query?(row["subject"], query)
    return true if content_matches_query?(row["author"], query)
    return true if content_matches_query?(row["body"], query)
    return false
  end

  def set_mozport_tokenizer!
    # http://wontfix-en.blogspot.nl/2010/04/how-to-view-messagetext-table-for.html
    tokenizer_hex = @db.execute("select hex(fts3_tokenizer('porter'));")[0][0]
    @db.execute("SELECT fts3_tokenizer('mozporter',X'#{tokenizer_hex}')")
  end
end

puts Thunderbird.search("update 01").map(&:subject)
