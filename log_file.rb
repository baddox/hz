class LogFile
  def initialize(file)
    @file = file
  end

  # Yields a hash representing each entry.
  def entries
    Enumerator.new do |y|
      entry = ""
      
      @file.each do |line|
        if line == "\n" && entry != ""
          begin
            parsed = self.class.parse_entry(entry)
          rescue => e
            # This happens for requests with exceptions or redirects.
            # In real life we would probably report something here.
          end
          y << parsed unless parsed.nil?
          entry = ""
        elsif line != "\n"
          entry += line
        end
      end
    end
  end

  # Parses a multi-line string into a hash.
  def self.parse_entry(entry)
    # Assumes all URLs will start with "http".
    url = entry.match(/\[(http.*)\]/).captures.first

    # Could use eval, but that's not fair or safe.
    params_string = entry.match(/\{(.*)\}/).captures.first
    params = Hash[params_string.split(",").map {|s| s.match(/"(.*)"=>"(.*)"/).captures}]

    # Matches any non-whitespace string for IP address (who knows, there could be IPv6 or some weird format).
    ip, time = entry.match(/for (\S+) at (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})/).captures

    # Time.parse uses Ruby's time zone.
    time = Time.parse(time)
    
    {
      url: url,
      params: params,
      ip: ip,
      time: time,
    }
  end
end
