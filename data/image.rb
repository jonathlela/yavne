require "data/positionnable.rb"
require "data/element.rb"

module Model

  class Image < SingleElement

    include Positionnable
    
    attr_reader :path
    
    def initialize(path,time=Element::NO_TIME)
      super(time)
      left()
      top()
      @path = path
      @type = "image"
    end
    
  end
  
end
