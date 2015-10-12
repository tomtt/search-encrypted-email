require 'sqlite3'

module Thunderbird
  class Database
    def initialize(filename:)
      @db = SQLite3::Database.new(filename.to_s)
      set_mozport_tokenizer!
    end

    def all_emails
      sql_query = <<-EOT
        SELECT
          docid,
          c0body as body,
          c1subject as subject,
          c2attachmentNames as attachment_names,
          c3author as author,
          c4recipients as recipients
        FROM messagesText_content;
      EOT
      rows = SelectResult.new(db: @db, query: sql_query).rows
   end

    private

    def set_mozport_tokenizer!
      # http://wontfix-en.blogspot.nl/2010/04/how-to-view-messagetext-table-for.html
      tokenizer_hex = @db.execute("select hex(fts3_tokenizer('porter'));")[0][0]
      @db.execute("SELECT fts3_tokenizer('mozporter',X'#{tokenizer_hex}')")
    end
  end
end
