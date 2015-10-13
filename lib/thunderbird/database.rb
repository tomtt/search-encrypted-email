require 'sqlite3'

module Thunderbird
  class Database
    def initialize(filename:)
      @db = SQLite3::Database.new(filename.to_s)
      # set_mozport_tokenizer!
    end

    def all_emails
      sql_query = <<-EOT
        SELECT
          content.docid as message_id,
          content.c0body as body,
          content.c1subject as subject,
          content.c2attachmentNames as attachment_names,
          content.c3author as author,
          content.c4recipients as recipients,
          messages.date as date

        FROM messagesText_content as content, messages
        WHERE messages.id = content.docid;
      EOT
      rows = SelectResult.new(db: @db, query: sql_query).rows do |row|
        row["time"] = Thunderbird::Database.convert_date_to_time(row.delete("date"))
        row
      end
   end

   def self.convert_date_to_time(date)
     Time.at(date / 1000000)
   end

    private

    def set_mozport_tokenizer!
      # This was nescesary when we were using the messagesText table but not any
      # longer now we are using the messagesText_content table. Leaving the code
      # here for now in case something else would require it.

      # http://wontfix-en.blogspot.nl/2010/04/how-to-view-messagetext-table-for.html
      # tokenizer_hex = @db.execute("select hex(fts3_tokenizer('porter'));")[0][0]
      # @db.execute("SELECT fts3_tokenizer('mozporter',X'#{tokenizer_hex}')")
    end
  end
end
