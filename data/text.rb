require "data/element.rb"

module Model

  class Text < SingleElement
    
    attr_reader :text, :color, :font, :size

    include Positionnable
    
    def initialize(text,color,font,size,time=Element::NO_TIME)
      super(time)
      @text = text
      @color = color
      @font = font
      @size = size
      @type = "text"
    end
    
  end

  
end
