require "data/positionnable.rb"
require "data/element.rb"

module Model

  class Image < Element

    include Positionnable
    
    attr_reader :image
    
    def initialize(path,time=Element::NO_TIME)
      super(time)
      left()
      top()
      @image = path
      @type = "image"
    end
    
  end
  
end
