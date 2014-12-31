require "treetop"
require "iphone_parser/version"
require 'iphone_parser/grammar'

module IphoneParser
  # Your code goes here...
  def self.parse(file_content)
    @@parser ||= IphoneResourceFileParser.new
    ast = @@parser.parse(file_content)
    if ast
      ast
    else
      error = @@parser.failure_reason =~ /^(Expected .+) after/m
      error += "#{$1.gsub("\n", '$NEWLINE')}:"
      error += data.lines.to_a[parser.failure_line - 1]
      error += "#{'~' * (parser.failure_column - 1)}^"
      raise error
    end
  end
end
