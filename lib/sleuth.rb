class Sleuth
  def initialize(search_options)
    @search_options = search_options
  end

  def entry_qualifies?(entry)
    entry_matches_search_options?(entry)
  end

  private

  def content_matches_search_options?(content)
    return false unless content
    @search_options[:query].each do |word|
      return false unless content.downcase.include?(word.downcase)
    end
    return true
  end

  def is_encrypted?(content)
    content && content.include?("BEGIN PGP MESSAGE")
  end

  def decrypt_body_if_encrypted(entry)
    if is_encrypted?(entry["body"])
      entry["body"] = GPG.decrypt(entry["body"])
    end
  end

  def entry_matches_search_options?(entry)
    return true if content_matches_search_options?(entry["subject"])
    return true if content_matches_search_options?(entry["author"])
    return true if content_matches_search_options?(entry["recipients"])
    return true if content_matches_search_options?(entry["attachment_names"])
    decrypt_body_if_encrypted(entry)
    return true if content_matches_search_options?(entry["body"])
    return false
  end
end
