# IphoneParser

Parser for iphone resource files - also can create those files.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'iphone_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iphone_parser

## Usage

Check the spec folder for lots of examples. A real usage would look like this:

    require 'iphone_parser'
    strings = IphoneParser.parse(File.open("Localizable.strings").read)
    strings['one label']
     => { text: 'the text for this label', comment: all comments on top of this string }


## Contributing

1. Fork it ( https://github.com/fotanus/iphone-parser/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
