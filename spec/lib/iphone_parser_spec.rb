require 'spec_helper'

describe IphoneParser do
  describe "IphoneParser.parse" do
    it "parse a simple entry" do
      resource_file = '"label"="text";'
      strings = IphoneParser.parse(resource_file)
      expect(strings.count).to eq(1)
      expect(strings['label'][:text]).to eq('text')

    end

    it "parse single line comments" do
      resource_file = <<-eof
        // my comment
        "label" = "text";
      eof

      strings = IphoneParser.parse(resource_file)
      expect(strings.count).to eq(1)
      expect(strings['label'][:text]).to eq('text')
      expect(strings['label'][:comments]).to match(/\/\/ my comment\n/)
    end

    it "parse multi line comments" do
      resource_file = <<-eof
      /* my comment */
      "label" = "text";
      eof
      strings = IphoneParser.parse(resource_file)
      expect(strings.count).to eq(1)
      expect(strings['label'][:comments]).to match(/\/\* my comment \*\//)
      expect(strings['label'][:text]).to eq("text")
    end

    it "parse multiple strings" do
      resource_file = <<-eof
      // comment 1
      "label 1" = "text 1";
      /* comment 2 */
      "label 2" = "text 2";
      eof
      strings = IphoneParser.parse(resource_file)
      expect(strings.count).to eq(2)
      expect(strings['label 1'][:comments]).to match(/\/\/ comment 1\n/)
      expect(strings['label 1'][:text]).to eq("text 1")
      expect(strings['label 2'][:comments]).to match(/\/\* comment 2 \*\//)
      expect(strings['label 2'][:text]).to eq("text 2")
    end

    it "semicolon is optional" do
      resource_file = <<-eof
      // comment 1
      "label 1" = "text 1"
      /* comment 2 */
      "label 2" = "text 2"
      eof
      strings = IphoneParser.parse(resource_file)
      expect(strings.count).to eq(2)
      expect(strings['label 1'][:comments]).to match(/\/\/ comment 1\n/)
      expect(strings['label 1'][:text]).to eq("text 1")
      expect(strings['label 2'][:comments]).to match(/\/\* comment 2 \*\//)
      expect(strings['label 2'][:text]).to eq("text 2")
    end

    it "accept escaped quotes" do
      resource_file = '"\"label\"1\"" = "\"text\"1\"";'
      strings = IphoneParser.parse(resource_file)
      expect(strings.count).to eq(1)
      expect(strings['\"label\"1\"'][:text]).to eq('\"text\"1\"')
    end

    it "parses two comments for same string" do
      resource_file = <<-eof
        /* my comment */
        // other comment
        "label1" = "text1";
        /* second comment */
        "label2" = "text2";
      eof
      strings = IphoneParser.parse(resource_file)
      expect(strings.count).to eq(2)
      expect(strings['label1'][:comments]).to match(/\/\* my comment \*\/.*\/\/ other comment/m)
      expect(strings['label1'][:text]).to eq('text1')
      expect(strings['label2'][:comments]).to match(/\/\* second comment \*\//)
      expect(strings['label2'][:text]).to eq('text2')
    end

    it "raises for invalid format" do
      resource_file = '"invalid""="format";'
      expect {
        strings = IphoneParser.parse(resource_file)
      }.to raise_error(IphoneParser::ParseError)
    end
  end

  describe "IphoneParser.create_resource_file" do
    it "creates simple file" do
      strings = {'label' => { text: 'text'} }
      expected_output = '"label"="text";'
      expect(IphoneParser.create_resource_file(strings)).to eq(expected_output)
    end

    it "ignore comments" do
      strings = { 'label' => {comments: 'something', text: 'text'} }
      expected_output = '"label"="text";'
      expect(IphoneParser.create_resource_file(strings)).to eq(expected_output)
    end

    it 'raises invalid entry if missing text' do
      strings = { 'label' => {} }
      expect {
        IphoneParser.create_resource_file(strings)
      }.to raise_error(IphoneParser::InvalidEntry)
    end

    it 'raises invalid entry for random objects as label' do
      strings = {'l' => { text: 't'}, Object.new => { text: 't' } }
      expect {
        IphoneParser.create_resource_file(strings)
      }.to raise_error(IphoneParser::InvalidEntry)
    end

    it 'raises invalid entry for random objects as text' do
      strings = {'l' => { text: 't'}, 'l2' => { text: Object.new } }
      expect {
        IphoneParser.create_resource_file(strings)
      }.to raise_error(IphoneParser::InvalidEntry)
    end
  end
end
