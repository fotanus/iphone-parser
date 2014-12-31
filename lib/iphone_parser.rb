require "treetop"
require "iphone_parser/version"
require 'iphone_parser/grammar'

module IphoneParser
  # Your code goes here...
  def self.parse(file_content)
    @@parser ||= IphoneResourceFileParser.new
    unless @@parser.parse(file_content)
      raise "#{@@parser.input}\n#{@@parser.failure_reason}"
    end
  end
end
