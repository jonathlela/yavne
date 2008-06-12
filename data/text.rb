require "data/element.rb"

module Model

  class Text < Element

    include Positionnable
    
    attr_reader :text, :color, :font, :size
    
    def initialize(text,color,font,size,time=Element::NOTIME)
      super(time)
      @text = text
      @color = color
      @font = font
      @size = size
      @type = "text"
    end
    
  end
  
end
