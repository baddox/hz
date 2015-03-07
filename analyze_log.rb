require "time"
require_relative "counter.rb"
require_relative "funnel.rb"
require_relative "log_file.rb"

COUNTERS = [
  "http://www.heyzap.com/",
  "http://www.heyzap.com/payments/",
  "http://www.heyzap.com/payments/get_item/.*",
  {
    :name => "Weebly plays",
    :proc => Proc.new {|entry| entry[:params]["embed_key"] == "12affbbace"},
  },
]

FUNNELS = [
  {
    name: "Publishers front page",
    test: "http://www.heyzap.com/",
    children: [
      {
        name: "new_site",
        test: "http://www.heyzap.com/publishers/new_site",
        children: [
          {
            name: "get_embed",
            test: "http://www.heyzap.com/publishers/get_embed/\w*",
          },
        ],
      },
    ],
  },
  {
    name: "Developer front page",
    test: "http://www.heyzap.com/",
    children: [
      {
        name:"developers",
        test: "http://www.heyzap.com/developers",
        children: [
          {
            name: "new_game",
            test: "http://www.heyzap.com/developers/new_game",
          },
          {
            name: "import_games",
            test: "http://www.heyzap.com/developers/import_games",
          },
          {
            name:"upload_game_simple",
            test: "http://www.heyzap.com/developers/upload_game_simple",
          },
        ],
      },
    ],
  },
]

counters = COUNTERS.map {|counter| Counter.new(counter)}
funnels = FUNNELS.map {|funnel| Funnel.new(funnel)}

file = File.open(ARGV[0])
log_file = LogFile.new(file)

log_file.entries.each do |entry|
  counters.each {|counter| counter.record_entry(entry)}
  funnels.each {|funnel| funnel.record_entry(entry)}
end

puts ""
puts "COUNTERS"
puts "========"
puts counters.map(&:to_s).join("\n\n")

puts ""
puts "FUNNELS"
puts "========"
puts funnels.map(&:to_s).join("\n\n")
