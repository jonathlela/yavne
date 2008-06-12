module Model

  class Position

    ABSOLUTE = "absolute"
    RELATIVE = "relative"
    ALIGNED = "aligned"

    attr_reader :kind, :relative
    attr_accessor :margin

    def initialize()
      @kind = ABSOLUTE
      @margin = 0
    end

    def relative_to(position)
      @kind = RELATIVE
      @relative = position
    end

    def aligned_with(position)
      @kind = ALIGNED
      @relative = position
    end

  end

  class VerticalPosition < Position
    
    TOP = "top"
    MIDDLE = "middle"
    BOTTOM = "bottom"

    attr_reader :pos

    def initialize(pos)
      super()
      @pos = pos
    end

  end

  class HorizontalPosition < Position
    
    LEFT = "left"
    CENTER = "center"
    RIGHT = "right"

    attr_reader :pos

    def initialize(pos)
      super()
      @pos = pos
    end

  end


end
