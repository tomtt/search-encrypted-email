require 'sqlite3'

module Thunderbird
  class Database
    def initialize
      @db = SQLite3::Database.new('global-messages-db.sqlite')
      set_mozport_tokenizer!
    end

    def all_emails
      SelectResult.new(db: @db, query: "select * from messagesText").rows
   end

    private

    def set_mozport_tokenizer!
      # http://wontfix-en.blogspot.nl/2010/04/how-to-view-messagetext-table-for.html
      tokenizer_hex = @db.execute("select hex(fts3_tokenizer('porter'));")[0][0]
      @db.execute("SELECT fts3_tokenizer('mozporter',X'#{tokenizer_hex}')")
    end
  end
end
