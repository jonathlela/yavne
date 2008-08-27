module Model

  class State

    attr_accessor :background, :sprites, :textbox, :music, :sfx, :elements, :next
    
    def initialize(id)
      @id = id
      @sprites = Array.new()
      @elements = Array.new()    
    end
    
    def next(environment)
      @next[environment]
    end
    
  end
  
end
