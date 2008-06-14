require "data/element.rb"
require "data/image.rb"
require "data/text.rb"
require "data/positionnable.rb"

module Model

  class Textbox < CompoundElement

    attr_reader :box, :texts

    include Positionnable

    def initialize(box)
      super([box])
      @box = box
      @texts = Array.new()
      @type = "textbox"
    end

    def add_text(text)
      @texts.push(text)
      add(text)
    end
    
  end


end
