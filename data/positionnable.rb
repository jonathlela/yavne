require "data/position.rb"

module Model

  module Positionnable 
    
    attr_reader :horizontal, :vertical

    private

    def horizontal_margin(margin)
      if margin != 0 then
        @horizontal.margin = margin
      end
    end

    def vertical_margin(margin)
      if margin != 0 then
        @vertical.margin = margin
      end
    end
    
    def horizontal_align(margin=0, positionnable=nil)
      if positionnable != nil then
        @horizontal.aligned_with(positionnable)
      end
      horizontal_margin(margin)
    end

    def vertical_align(margin=0, positionnable=nil)
      if positionnable != nil then
        @vertical.aligned_with(positionnable)
      end
      vertical_margin(margin)
    end

    def horizontal_relative(margin=0, positionnable=nil)
      if positionnable != nil then
        @horizontal.relative_to(positionnable)
      end
      horizontal_margin(margin)
    end

    def vertical_relative(margin=0, positionnable=nil)
      if positionnable != nil then
        @vertical.relative_to(positionnable)
      end
      vertical_margin(margin)
    end

    public
    
    def align_left(positionnable, margin=0)
      @horizontal=HorizontalPosition.new(HorizontalPosition::LEFT)
      horizontal_align(margin,positionnable)
    end

    def left_of(positionnable, margin=0)
      @horizontal=HorizontalPosition.new(HorizontalPosition::LEFT)
      horizontal_relative(margin,positionnable)
    end

    def left(margin=0)
      @horizontal=HorizontalPosition.new(HorizontalPosition::LEFT)
      horizontal_margin(margin)
    end

    def align_center(positionnable, margin=0)
      @horizontal=HorizontalPosition.new(HorizontalPosition::CENTER)
      horizontal_align(margin,positionnable)
    end

    def center_of(positionnable, margin=0)
      @horizontal=HorizontalPosition.new(HorizontalPosition::CENTER)
      horizontal_relative(margin,positionnable)
    end

    def center(margin=0)
      @horizontal=HorizontalPosition.new(HorizontalPosition::CENTER)
      horizontal_margin(margin)
    end

    def align_right(positionnable, margin=0)
      @horizontal=HorizontalPosition.new(HorizontalPosition::RIGHT)
      horizontal_align(margin,positionnable)
    end

    def right_of(positionnable, margin=0)
      @horizontal=HorizontalPosition.new(HorizontalPosition::RIGHT)
      horizontal_relative(margin,positionnable)
    end

    def right(margin=0)
      @horizontal=HorizontalPosition.new(HorizontalPosition::RIGHT)
      horizontal_margin(margin)
    end

    def align_top(positionnable, margin=0)
      @vertical=VerticalPosition.new(VerticalPosition::TOP)
      vertical_align(margin,positionnable)
    end

    def top_of(positionnable, margin=0)
      @vertical=VerticalPosition.new(VerticalPosition::TOP)
      vertical_relative(margin,positionnable)
    end

    def top(margin=0)
      @vertical=VerticalPosition.new(VerticalPosition::TOP)
      vertical_margin(margin)
    end

    def align_middle(positionnable, margin=0)
      @vertical=VerticalPosition.new(VerticalPosition::MIDDLE)
      vertical_align(margin,positionnable)
    end

    def middle_of(positionnable, margin=0)
      @vertical=VerticalPosition.new(VerticalPosition::MIDDLE)
      vertical_relative(margin,positionnable)
    end

    def middle(margin=0)
      @vertical=VerticalPosition.new(VerticalPosition::MIDDLE)
      vertical_margin(margin)
    end

    def align_bottom(positionnable, margin=0)
      @vertical=VerticalPosition.new(VerticalPosition::BOTTOM)
      vertical_align(margin,positionnable)
    end

    def bottom_of(positionnable, margin=0)
      @vertical=VerticalPosition.new(VerticalPosition::BOTTOM)
      vertical_relative(margin,positionnable)
    end

    def bottom(margin=0)
      @vertical=VerticalPosition.new(VerticalPosition::BOTTOM)
      vertical_margin(margin)
    end

  end

end
