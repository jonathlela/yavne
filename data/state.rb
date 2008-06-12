module Model

class State

  @@ids = 0

  attr_accessor :background, :sprites, :textbox, :text, :sfx, :elements, :next

  def initialize()
    @@ids += 1
    @id = @@ids
    @sprites = Array.new()
    @elements = Array.new()    
  end

  def next(environment)
    @next[environment]
  end

end

end
