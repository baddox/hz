module Helpers
  # Tests whether a URL matches a regex. Allows for optional query string at the end of the URL.
  def test_url(url, regex)
    optional_url_params = "(\\?.*)?"
    regex += optional_url_params if regex.end_with?("/")
    
    # Only accept matches on the entire string. Is there a cleaner way to do this?
    regex = "^" + regex + "$"

    return url.match(regex)
  end

  # Adds a certain amount of indentation to a line of text.
  def indent(text, level)
    tab = "  " * level
    tab + text.to_s
  end
end
