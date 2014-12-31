module IphoneParser
  class ParseError < StandardError ; end
  class InvalidEntry < StandardError
    def to_s
      "Should provide a hash like: {'label' => {text: 'text'}}"
    end
  end
end
