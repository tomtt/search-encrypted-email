module Thunderbird
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
    Dir.glob(File.join(Thunderbird.root, 'lib', '**', "*.rb")) { |file| yield(file) }
  end

  def self.search(query)
    Thunderbird::Database.new.search(query)
  end
end

Thunderbird.require_all
