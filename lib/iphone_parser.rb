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
      generate_hash(ast)
    else
      @@parser.failure_reason =~ /^(Expected .+) after/m
      error = "#{$1.gsub("\n", '$NEWLINE')}:" + "\n"
      error += file_content.lines.to_a[@@parser.failure_line - 1]
      error += "#{'~' * (@@parser.failure_column - 1)}^"
      raise ParseError, error
    end
  end

  def self.create_resource_file(entries)
    raise InvalidEntry unless entries.kind_of? Hash

    entries.reduce("") do |out, entry|
      label = entry[0]
      text_and_comment = entry[1]
      raise InvalidEntry unless text_and_comment.kind_of?(Hash)
      text = text_and_comment[:text]

      raise InvalidEntry if !label.kind_of?(String) || !text.kind_of?(String)

      out += "\"#{label}\"=\"#{text_and_comment[:text]}\";"
    end
  end

  private

    def self.generate_hash(ast)
      ast.elements.delete_if { |node| !node.kind_of? Entry }

      hash_constructor = ast.elements.map do |entry|
        label = entry.label.text_value[1..-2]
        text = entry.text.text_value[1..-2]
        comments = entry.comments.text_value
        [ label, {text: text, comments: comments} ]
      end

      Hash[hash_constructor]
    end
end
