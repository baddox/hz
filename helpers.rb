module Helpers
  REGEX_CACHE = {}
  
  # Tests whether a URL matches a regex. Allows for optional query string at the end of the URL.
  def test_url(url, regex)
    if REGEX_CACHE[regex]
      r = REGEX_CACHE[regex]
    else
      optional_url_params = "(\\?.*)?"
      if regex.end_with?("/")
        r = regex + optional_url_params 
      else
        r = regex
      end
      
      # Only accept matches on the entire string. Is there a cleaner way to do this?
      r = Regexp.new("^" + r + "$")

      # Cache that regex.
      REGEX_CACHE[regex] = r
    end

    return url.match(r)
  end

  # Adds a certain amount of indentation to a line of text.
  def indent(text, level)
    tab = "  " * level
    tab + text.to_s
  end
end
