require 'spec_helper'

describe IphoneParser do
  it "parse a simple entry" do
    resource_file = '"label"="text";'
    IphoneParser.parse(resource_file)
  end

  it "parse single line comments" do
    resource_file = <<-eof
      // my comment
      "label" = "text";
    eof

    IphoneParser.parse(resource_file)
  end

  it "parse multi line comments" do
    resource_file = <<-eof
    /* my comment */
    "label" = "text";
    eof
    IphoneParser.parse(resource_file)
  end

  it "parse multiple strings" do
    resource_file = <<-eof
    // comment 1
    "label 1" = "text 1";
    /* comment 2 */
    "label 2" = "text 2";
    eof
    IphoneParser.parse(resource_file)
  end

  it "accept escaped quotes" do
    resource_file = '"\"label\"1\"" = "\"text\"1\"";'
    IphoneParser.parse(resource_file)
  end

  it "raises for invalid format" do
    resource_file = '"invalid""="format";'
    expect {
      IphoneParser.parse(resource_file)
    }.to raise_error(IphoneParser::ParseError)
  end
end
