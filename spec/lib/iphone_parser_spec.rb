require 'spec_helper'

describe IphoneParser do
  it "parse a simple entry" do
    resource_file = '"label"="text";'
    entries = IphoneParser.parse(resource_file)
    expect(entries.count).to eq(1)
    expect(entries.first[:comments]).to be_blank
    expect(entries.first[:label]).to eq("label")
    expect(entries.first[:text]).to eq("text")

  end

  it "parse single line comments" do
    resource_file = <<-eof
      // my comment
      "label" = "text";
    eof

    entries = IphoneParser.parse(resource_file)
    expect(entries.count).to eq(1)
    expect(entries.first[:comments]).to match(/\/\/ my comment\n/)
    expect(entries.first[:label]).to eq("label")
    expect(entries.first[:text]).to eq("text")
  end

  it "parse multi line comments" do
    resource_file = <<-eof
    /* my comment */
    "label" = "text";
    eof
    entries = IphoneParser.parse(resource_file)
    expect(entries.count).to eq(1)
    expect(entries.first[:comments]).to match(/\/\* my comment \*\//)
    expect(entries.first[:label]).to eq("label")
    expect(entries.first[:text]).to eq("text")
  end

  it "parse multiple strings" do
    resource_file = <<-eof
    // comment 1
    "label 1" = "text 1";
    /* comment 2 */
    "label 2" = "text 2";
    eof
    entries = IphoneParser.parse(resource_file)
    expect(entries.count).to eq(2)
    expect(entries[0][:comments]).to match(/\/\/ comment 1\n/)
    expect(entries[0][:label]).to eq("label 1")
    expect(entries[0][:text]).to eq("text 1")
    expect(entries[1][:comments]).to match(/\/\* comment 2 \*\//)
    expect(entries[1][:label]).to eq("label 2")
    expect(entries[1][:text]).to eq("text 2")
  end

  it "accept escaped quotes" do
    resource_file = '"\"label\"1\"" = "\"text\"1\"";'
    entries = IphoneParser.parse(resource_file)
    expect(entries.first[:label]).to eq('\"label\"1\"')
    expect(entries.first[:text]).to eq('\"text\"1\"')
  end

  it "raises for invalid format" do
    resource_file = '"invalid""="format";'
    expect {
      entries = IphoneParser.parse(resource_file)
    }.to raise_error(IphoneParser::ParseError)
  end
end
