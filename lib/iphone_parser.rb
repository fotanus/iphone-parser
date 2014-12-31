require "treetop"
require "iphone_parser/version"
require 'iphone_parser/ast_nodes'
require 'iphone_parser/grammar'
require 'iphone_parser/exceptions'

module IphoneParser
  def self.parse(file_content)
    @@parser ||= IphoneResourceFileParser.new
    ast = @@parser.parse(file_content)
    if ast
      ast.elements.delete_if { |node| !node.kind_of? Entry }
      ast.elements.map do |entry|
        {
          comments: entry.comments.text_value,
          label: entry.label.text_value[1..-2],
          text: entry.text.text_value[1..-2],
        }
      end
    else
      @@parser.failure_reason =~ /^(Expected .+) after/m
      error = "#{$1.gsub("\n", '$NEWLINE')}:" + "\n"
      error += file_content.lines.to_a[@@parser.failure_line - 1]
      error += "#{'~' * (@@parser.failure_column - 1)}^"
      raise ParseError, error
    end
  end

  def self.create_resource_file(entries)
    raise InvalidEntry unless entries.kind_of? Array
    entries.reduce("") do |out, entry|
      unless entry.kind_of?(Hash)
        raise InvalidEntry, "This entry is not a hash: #{entry.inspect}"
      end
      unless entry[:label] && entry[:text]
        raise InvalidEntry, "Each entry should have label and text. This one does not: #{entry.inspect}"
      end
      out += "\"#{entry[:label]}\"=\"#{entry[:text]}\";"
    end
  end
end
