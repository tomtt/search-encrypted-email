class Sleuth
  def initialize(query)
    @query = query
  end

  def entry_qualifies?(entry)
    entry_matches_query?(entry)
  end

  private

  def content_matches_query?(content)
    content && content.include?(@query)
  end

  def is_encrypted?(content)
    content && content.include?("BEGIN PGP MESSAGE")
  end

  def entry_matches_query?(entry)
    return true if content_matches_query?(entry["subject"])
    return true if content_matches_query?(entry["author"])
    if is_encrypted?(entry["body"])
      return true if content_matches_query?(GPG.decrypt(entry["body"]))
    else
      return true if content_matches_query?(entry["body"])
    end
    return false
  end

end
