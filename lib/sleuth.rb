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
      return false unless content.include?(word)
    end
    return true
  end

  def is_encrypted?(content)
    content && content.include?("BEGIN PGP MESSAGE")
  end

  def entry_matches_search_options?(entry)
    return true if content_matches_search_options?(entry["subject"])
    return true if content_matches_search_options?(entry["author"])
    return true if content_matches_search_options?(entry["recipients"])
    return true if content_matches_search_options?(entry["attachment_names"])
    if is_encrypted?(entry["body"])
      return true if content_matches_search_options?(GPG.decrypt(entry["body"]))
    else
      return true if content_matches_search_options?(entry["body"])
    end
    return false
  end

end
