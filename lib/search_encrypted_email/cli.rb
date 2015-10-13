module SearchEncryptedEmail
  class CLI
    def self.options_for_search
      { query: ARGV }
    end
  end
end
