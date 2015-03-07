require "set"
require_relative "helpers.rb"

class Counter
  include Helpers
  
  attr_accessor :counter_definition
  attr_accessor :total
  attr_accessor :ips
  
  def initialize(counter_definition)
    self.counter_definition = counter_definition
    self.total = 0
    self.ips = Set.new
  end

  def record_entry(entry)
    if matches?(entry)
      self.total += 1
      ips << entry[:ip]
    end
  end

  def matches?(entry)
    if counter_definition.is_a?(Hash)
      return counter_definition[:proc].call(entry)
    else
      return test_url(entry[:url], counter_definition)
    end
  end

  def uniques
    ips.count
  end

  def name
    if counter_definition.is_a?(Hash)
      counter_definition[:name]
    else
      counter_definition
    end
  end

  def to_s
    [
      name,
      indent("Total: #{total}", 1),
      indent("Uniqs: #{uniques}", 1),
    ].join("\n")
  end
end
