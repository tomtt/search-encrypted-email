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
end

SearchEncryptedEmail.require_all
