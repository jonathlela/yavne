module View
  
  module Positionnable
   
    attr_reader :x, :y

    def set_pos(x,y)
      @x, @y = x, y
    end

  end 

end
