require "set"
require_relative "helpers.rb"

class Funnel
  include Helpers

  attr_accessor :name
  attr_accessor :test
  attr_accessor :children
  attr_accessor :total
  attr_accessor :ips
  
  def initialize(funnel_definition)
    self.name = funnel_definition[:name]
    self.test = funnel_definition[:test]
    
    children_definitions = funnel_definition[:children] || []
    self.children = children_definitions.map {|funnel_def| Funnel.new(funnel_def)}
    
    self.total = 0
    self.ips = Set.new
  end

  def record_entry(entry)
    # If this user has already hit this step in the funnel, pass the entry on to the children.
    # This means we only accept visits to a funnel child after the user has visited its parent.
    if ips.include?(entry[:ip])
      children.each {|funnel| funnel.record_entry(entry)}
    end
    
    if matches?(entry)
      self.total += 1
      ips << entry[:ip]
    end
  end

  def matches?(entry)
    if test.respond_to?(:call)
      return test.call(entry)
    else
      return test_url(entry[:url], test)
    end
  end

  def uniques
    ips.count
  end

  def to_s(level=0, last_child=false)
    lines = [
      indent(name, level),
      indent("Total: #{total}", level + 1),
      indent("Uniqs: #{uniques}", level + 1),
    ]

    if !children.empty?
      lines << ""
      lines << indent("Children:", level + 1)
      children_lines = children.map {|funnel, index| funnel.to_s(level + 2)}
      lines = lines.concat(children_lines)
    end


    return lines.join("\n")
  end
end
