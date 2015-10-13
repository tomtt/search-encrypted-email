module SearchEncryptedEmail
  def self.root
    Pathname.new(File.absolute_path(File.join(File.dirname(__FILE__), '..')))
  end

  def self.require_all
    with_ruby_files { |file| require file}
  end

  def self.load_all
    with_ruby_files do |file|
      puts "loading #{file}"
      load file
    end
  end

  def self.with_ruby_files(&block)
    Dir.glob(File.join(SearchEncryptedEmail.root, 'lib', '**', "*.rb")) { |file| yield(file) }
  end

  def self.search(search_options)
    sleuth = Sleuth.new(search_options)
    Thunderbird::Database.new(filename: 'global-messages-db.sqlite').all_emails.select do |email_entry|
      sleuth.entry_qualifies?(email_entry)
    end
  end

  def self.output_for_result(result)
    s = ""
    s << "SUBJECT: #{result["subject"]}\n"
    s << "TIME: #{result["time"].rfc822}\n"
    s << "FROM: #{result["author"]}\n"
    s << "TO: #{result["recipients"]}\n"
    unless result["attachment_names"].empty?
      s << "ATTACHMENT_NAMES: #{result["attachment_names"]}\n"
    end
    if result["body"]
      s << "---\n" << result['body'] << "\n"
    else
      s << "<no body>\n"
    end
    s << '-' * 80 + "\n"
    s.force_encoding('UTF-8')
    s
  end

  def self.print_report(results)
    puts results.map { |result| output_for_result(result) }.join
  end
end

SearchEncryptedEmail.require_all
