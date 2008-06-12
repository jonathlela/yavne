module View
  
  module Positionnable
    
    attr_accessor :x, :y
    
    def initialize(x,y)
      @x , @y = x, y
    end
    
    def set_pos(x,y)
      @x , @y = x, y
    end
    
  end

end
