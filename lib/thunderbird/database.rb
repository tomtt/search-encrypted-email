require 'sqlite3'

module Thunderbird
  class Database
    def initialize
      @db = SQLite3::Database.new('global-messages-db.sqlite')
      set_mozport_tokenizer!
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

    def is_encrypted?(content)
      false
    end

    def row_matches_query?(row, query)
      return true if content_matches_query?(row.subject, query)
      return true if content_matches_query?(row.author, query)
      if is_encrypted?(row.body)
        return true if content_matches_query?(GPG.decrypt(row.body), query)
      else
        return true if content_matches_query?(row.body, query)
      end
      return false
    end

    def set_mozport_tokenizer!
      # http://wontfix-en.blogspot.nl/2010/04/how-to-view-messagetext-table-for.html
      tokenizer_hex = @db.execute("select hex(fts3_tokenizer('porter'));")[0][0]
      @db.execute("SELECT fts3_tokenizer('mozporter',X'#{tokenizer_hex}')")
    end
  end
end
