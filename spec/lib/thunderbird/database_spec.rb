require 'spec_helper'
require 'fileutils'

describe Thunderbird::Database do
  describe '#all_emails' do
    tmp_db_file = SearchEncryptedEmail.root.join("spec",
     "tmp" ,  "dummy-db.sqlite")

    before(:all) do
      begin
        FileUtils.rm(tmp_db_file)
      rescue Errno::ENOENT => e
        # Only trying to ensure no old database exists, if it does not, that's
        # fine

        # Ensure the spec/tmp directory exists though
        FileUtils.mkdir_p(SearchEncryptedEmail.root.join("spec", "tmp"))
      end

      db = SQLite3::Database.new(tmp_db_file.to_s)

      create_messages_table_sql = <<-EOT
CREATE TABLE messages (
  id INTEGER PRIMARY KEY,
  folderID INTEGER,
  messageKey INTEGER,
  conversationID INTEGER NOT NULL,
  date INTEGER,
  headerMessageID TEXT,
  deleted INTEGER NOT NULL default 0,
  jsonAttributes TEXT,
  notability INTEGER NOT NULL default 0
);
EOT

      create_content_table_sql = <<-EOT
CREATE TABLE messagesText_content (
  docid INTEGER PRIMARY KEY,
  c0body,
  c1subject,
  c2attachmentNames,
  c3author,
  c4recipients
);
EOT

      db.execute create_messages_table_sql
      db.execute create_content_table_sql
      db.execute "INSERT INTO messages (id, date, conversationID) VALUES (1, 1427124710000000, 1)"
      db.execute "INSERT INTO messages (id, date, conversationID) VALUES (2, 1427127710000000, 1)"
      db.execute <<EOT
INSERT INTO messagesText_content (
  docid,
  c0body,
  c1subject,
  c2attachmentNames,
  c3author,
  c4recipients)
VALUES (
  1,
  'dummy one body',
  'dummy one subject',
  'dummy one attachmentNames',
  'dummy one author',
  'dummy one recipients'
);
EOT

      db.execute <<EOT
INSERT INTO messagesText_content (
  docid,
  c0body,
  c1subject,
  c2attachmentNames,
  c3author,
  c4recipients)
VALUES (
  2,
  'dummy two body',
  'dummy two subject',
  'dummy two attachmentNames',
  'dummy two author',
  'dummy two recipients'
);
EOT
    end

    it "has the info of all messages" do
      emails = Thunderbird::Database.new(filename: tmp_db_file).all_emails

      one_expected_attributes = {
        "message_id" =>       1,
        "body" =>             "dummy one body",
        "subject" =>          "dummy one subject",
        "attachment_names" => "dummy one attachmentNames",
        "author" =>           "dummy one author",
        "recipients" =>       "dummy one recipients",
        "time" => Thunderbird::Database.convert_date_to_time(1427124710000000)
      }

      two_expected_attributes = {
        "message_id"=>        2,
        "body" =>             "dummy two body",
        "subject" =>          "dummy two subject",
        "attachment_names" => "dummy two attachmentNames",
        "author" =>           "dummy two author",
        "recipients" =>       "dummy two recipients",
        "time" => Thunderbird::Database.convert_date_to_time(1427127710000000)
      }

      expect(emails.size).to eq 2
      expect(emails).to include(one_expected_attributes)
      expect(emails).to include(two_expected_attributes)
    end
  end

  describe '.convert_date_to_time' do
    it "converts 1427124710000000 to 2015-03-23 16:31:50" do
      expect(Thunderbird::Database.convert_date_to_time(1427124710000000)).to eq Time.new(2015,3,23,16,31,50)
    end
  end
end
